import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

class Scanner {
  final String _source;
  final List<Token> _tokens = [];

  int _start = 0;
  int _current = 0;
  int _line = 1;

  Scanner(this._source);

  bool get _isAtEnd => _current >= _source.length;

  String _advance() {
    _current++;
    return _source[_current - 1];
  }

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
        } else {
          addToken(TokenType.slash);
        }
        break;
      case ' ':
      case '\r':
      case '\t':
        break;
      case '\n':
        _line++;
        break;
      default:
        Lox.error(_line, 'Unexpected character.');
        break;
    }
  }
}
