import 'package:dlox/ast/expr.dart';
import 'package:dlox/ast/stmt.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

/// Grammar rules:
/// ```
/// // Biểu thức
/// expression     → equality
/// comma          → equality ("," equality)?
/// // Đẳng thức
/// equality       → comparison ( ( "!=" | "==" ) comparison )*
/// // So sách
/// comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )*
/// // Phép cộng trừ
/// term           → factor ( ( "-" | "+" ) factor )*
/// // Phép nhân chia
/// factor         → unary ( ( "/" | "*" ) unary )*
/// // Toán tử một ngôi
/// unary          → ( "!" | "-" ) unary
///                | primary
/// primary        → NUMBER | STRING | "true" | "false" | "nil"
///                | "(" expression ")"
///```
///
/// Parser của Lox sẽ tiếp cận theo hướng từ trên xuống dưới.
/// Đệ quy đến lúc parse hết các tokens (Từ khóa) → exprs (Câu lệnh).
///
/// <b>Challenge 1 (Chapter 6):</b>
/// - Toán tử dấu ",".
///   - Toán tử dấu "," để tách các expression.
///   - Ex: "var a, b, c;", "foo(a, b, c) { ... }" ...
///   - Thứ tự ưu tiên sau đẳng thức.
///   - Cú pháp:
///     ```
///       expression → comma
///       comma      → equality ("," equality)*
///       equality   → ...
///     ```
/// - Postfix "++" "--".
///   - Ex: a++, b++, c--, ...
///   - Độ ưu tiên cao hơn toán tử một ngôi vì trách việc parser hiểu lầm toán tử một ngôi "-" với postfix "--".
///   - Cú pháp:
///     ```
///       unary    → ...
///       postfix  → ("++" | "--")? primary;
///       primary  → ...
///     ```
/// - Prefix "++" "--".
/// - Giúp tách các expression.
///
/// Cú pháp của các câu lệnh (statements):
/// ```
/// program        → statement* EOF
/// statement      → exprStmt
///                | printStmt
/// exprStmt       → expression ";"
/// printStmt      → "print" expression ";"
/// ```
class Parser {
  Parser(this._tokens);
  final List<Token> _tokens;
  int _current = 0;

  List<Stmt>? tryParse() {
    List<Stmt> stmts = [];
    try {
      while (!_isAtEnd) {
        stmts.add(_statement());
      }
      return stmts;
    } on ParserError catch (_) {
      return null;
    }
  }

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

  Expr _comma() {
    Expr expr = _equality();

    while (_match([TokenType.comma])) {
      Token token = _previous();
      Expr right = _equality();
      expr = Expr.binary(expr, token, right);
    }

    return expr;
  }

  Expr _expression() => _conditional();

  Expr _conditional() {
    Expr expr = _equality();

    if (_match([TokenType.question])) {
      Expr thenBranch = _expression();
      _consume(TokenType.colon, 'Expect ":" after then branch of conditional expression.');
      Expr elseBranch = _expression();

      expr = Expr.conditional(expr, thenBranch, elseBranch);
    }

    return expr;
  }

  Expr _equality() {
    Expr expr = _comparison();

    while (_match([TokenType.bangEqual, TokenType.equalEqual])) {
      Token operator = _previous();
      Expr right = _comparison();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _comparison() {
    Expr expr = _term();

    while (_match([TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual])) {
      Token operator = _previous();
      Expr right = _term();

      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _term() {
    Expr expr = _factor();

    while (_match([TokenType.plus, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _factor();

      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _factor() {
    Expr expr = _unary();

    while (_match([TokenType.slash, TokenType.star])) {
      Token operator = _previous();
      Expr right = _unary();

      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _unary() {
    if (_match([TokenType.bang, TokenType.minus])) {
      Token operator = _previous();
      Expr right = _unary();

      return Expr.unary(operator, right);
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

      return Expr.grouping(expression);
    }

    throw ParserError();
  }

  Stmt _statement() {
    if (_match([TokenType.kPrint])) return _printStmt();
    return _expressionStmt();
  }

  Stmt _printStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ; after value.');

    return Stmt.printStmt(expression);
  }

  Stmt _expressionStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ; after expression.');

    return Stmt.expressionStmt(expression);
  }
}

class ParserError extends Error {}
