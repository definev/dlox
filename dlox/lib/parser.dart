import 'package:dlox/ast/ast.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

/// Grammar rules:
/// ```
/// expression     → equality
/// equality       → comparison ( ( "!=" | "==" ) comparison )*
/// comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )*
/// term           → factor ( ( "-" | "+" ) factor )*
/// factor         → unary ( ( "/" | "*" ) unary )*
/// unary          → ( "!" | "-" ) unary
///                | primary
/// primary        → NUMBER | STRING | "true" | "false" | "nil"
///                | "(" expression ")"
///```
class Parser {
  Parser(this._tokens);
  final List<Token> _tokens;
  int _current = 0;

  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_checkType(type)) {
        _advance();
        return true;
      }
    }

    return false;
  }

  bool _checkType(TokenType type) {
    if (_isAtEnd) return false;
    return _peek().type == type;
  }

  Token _peek() => _tokens[_current];

  Token _previous() => _tokens[_current - 1];

  bool get _isAtEnd => _peek().type == TokenType.eof;

  Token _advance() {
    if (!_isAtEnd) _current++;
    return _previous();
  }

  Token _consume(TokenType type, String message) {
    if (_checkType(type)) return _advance();

    throw _error(_peek(), message);
  }

  ParserError _error(Token token, String message) {
    Lox.parserError(token, message);
    return ParserError();
  }

  void _synchronize() {
    _advance();

    while (!_isAtEnd) {
      if (_peek().type == TokenType.semicolon) return;

      switch (_peek().type) {
        case TokenType.kClass:
          break;
        case TokenType.kVar:
        case TokenType.kIf:
        case TokenType.kElse:
        case TokenType.kFor:
        case TokenType.kWhile:
        case TokenType.kFun:
        case TokenType.kPrint:
        case TokenType.kReturn:

        default:
          return;
      }

      _advance();
    }
  }

  Expr _expression() => _equality();

  Expr _equality() {
    Expr expr = _comparison();

    while (_match([TokenType.bangEqual, TokenType.equalEqual])) {
      Token operator = _previous();
      Expr right = _comparison();
      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _comparison() {
    Expr expr = _term();

    while (_match([TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual])) {
      Token operator = _previous();
      Expr right = _term();

      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _term() {
    Expr expr = _factor();

    while (_match([TokenType.slash, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _factor();

      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _factor() {
    Expr expr = _unary();

    while (_match([TokenType.slash, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _unary();

      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _unary() {
    if (_match([TokenType.bang, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _unary();

      return Unary(operator, right);
    }

    return _primary();
  }

  Expr _primary() {
    Token token = _peek();

    if (_match([TokenType.kTrue])) return Literal(true);
    if (_match([TokenType.kFalse])) return Literal(false);
    if (_match([TokenType.kNil])) return Literal(null);

    if (_match([TokenType.number, TokenType.string])) return Literal(token.literal);
    if (_match([TokenType.leftBrace])) {
      Expr expression = _expression();

      _consume(TokenType.rightBrace, 'Expect expression.');

      return Grouping(expression);
    }

    throw ParserError();
  }

  Expr? tryParse() {
    try {
      return _expression();
    } on ParserError catch (_) {
      return null;
    }
  }
}

class ParserError extends Error {}
