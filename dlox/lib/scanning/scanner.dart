import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

class Scanner {
  final String _source;
  final List<Token> _tokens = [];

  static const Map<String, TokenType> _keywords = {
    'and': TokenType.kAnd,
    'class': TokenType.kClass,
    'else': TokenType.kElse,
    'false': TokenType.kFalse,
    'for': TokenType.kFor,
    'fun': TokenType.kFun,
    'if': TokenType.kIf,
    'nil': TokenType.kNil,
    'or': TokenType.kOr,
    'print': TokenType.kPrint,
    'return': TokenType.kReturn,
    'super': TokenType.kSuper,
    'this': TokenType.kThis,
    'true': TokenType.kTrue,
    'var': TokenType.kVar,
    'while': TokenType.kWhile,
  };

  int _start = 0;
  int _current = 0;
  int _line = 1;

  Scanner(this._source);

  bool get _isAtEnd => _current >= _source.length;

  String _advance() => _source[_current++];

  void addToken(TokenType type) {
    _addToken(type, null);
  }

  void _addToken(TokenType type, Object? literal) {
    String lexeme = _source.substring(_start, _current);
    _tokens.add(Token(type: type, lexeme: lexeme, literal: literal, line: _line));
  }

  bool _match(String expected) {
    if (_isAtEnd) return false;
    if (_source[_current] != expected) return false;
    _current++;
    return true;
  }

  String _peek() {
    if (_isAtEnd) return '\x00';
    return _source[_current];
  }

  String _peekNext() {
    if (_source.length >= _current + 1) return '\x00';
    return _source[_current + 1];
  }

  bool _isAlpha(String char) => RegExp(r'[a-z _][A-Z]').hasMatch(char);

  bool _isAlphaNumeric(String char) => _isAlpha(char) || _isDigit(char);

  List<Token> scanTokens() {
    while (!_isAtEnd) {
      _start = _current;
      _scanToken();
    }

    _tokens.add(Token(type: TokenType.eof, lexeme: '', literal: null, line: _line));
    return _tokens;
  }

  void _scanToken() {
    /// Lấy kí tự ở vị trí hiện tại và ghép nối với từng token
    String c = _advance();
    switch (c) {
      case '{':
        addToken(TokenType.leftParen);
        break;
      case '}':
        addToken(TokenType.rightParen);
        break;
      case '(':
        addToken(TokenType.leftBrace);
        break;
      case ')':
        addToken(TokenType.rightBrace);
        break;
      case ',':
        addToken(TokenType.comma);
        break;
      case '.':
        addToken(TokenType.dot);
        break;
      case '-':
        addToken(TokenType.minus);
        break;
      case '+':
        addToken(TokenType.plus);
        break;
      case ';':
        addToken(TokenType.semicolon);
        break;
      case '*':
        addToken(TokenType.star);
        break;
      case '!':
        addToken(_match('=') ? TokenType.bangEqual : TokenType.bang);
        break;
      case '=':
        addToken(_match('=') ? TokenType.equalEqual : TokenType.equal);
        break;
      case '>':
        addToken(_match('=') ? TokenType.greaterEqual : TokenType.greater);
        break;
      case '<':
        addToken(_match('=') ? TokenType.lessEqual : TokenType.less);
        break;
      case '/':
        if (_match('/')) {
          while (_peek() != '\n' && !_isAtEnd) {
            _advance();
          }
        } else if (_match('*')) {
          while ((!_isAtEnd) && (_peek() != '*' && _peekNext() != '/')) {
            _advance();
          }
        } else {
          addToken(TokenType.slash);
        }
        break;
      case '?':
        addToken(TokenType.question);
        break;
      case ':':
        addToken(TokenType.colon);
        break;
      case ' ':
      case '\r':
      case '\t':
        break;
      case '\n':
        _line++;
        break;
      case '"':
        _string();
        break;
      default:
        if (_isDigit(c)) {
          _number();
        } else if (_isAlpha(c)) {
          _identifier();
        } else {
          Lox.error(_line, 'Unexpected character.');
        }
        break;
    }
  }

  void _identifier() {
    while (_isAlphaNumeric(_peek())) {
      _advance();
    }

    String text = _source.substring(_start, _current);
    TokenType? type = _keywords[text];
    type ??= TokenType.identifier;
    addToken(type);
  }

  void _string() {
    while (_peek() != '"' && !_isAtEnd) {
      if (_peek() == '\n') _line++;
      _advance();
    }

    if (_isAtEnd) {
      Lox.error(_line, 'Unterminated string.');
      return;
    }

    String value = _source.substring(_start + 1, _current - 1);
    _addToken(TokenType.string, value);
  }

  bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);

  void _number() {
    while (_isDigit(_peek())) {
      _advance();
    }

    if (_peek() == '.' && _isDigit(_peekNext())) {
      _advance();

      while (_isDigit(_peek())) {
        _advance();
      }
    }

    _addToken(TokenType.number, double.parse(_source.substring(_start, _current)));
  }
}
