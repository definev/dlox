import 'package:dlox/ast/expr.dart';
import 'package:dlox/ast/stmt.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

/// Grammar rules:
/// ```
/// // Biểu thức
/// expression     → comma
/// // Chia biểu thức qua dâu ","
/// comma          → condition ("," condition)?
/// // Toán tử ba ngôi
/// condition      → equality ( "?" condition ":" condition )?
/// // Đẳng thức
/// equality       → comparison ( ( "!=" | "==" ) comparison )*
/// // So sách
/// comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )*
/// // Phép cộng trừ
/// term           → factor ( ( "-" | "+" ) factor )*
/// // Phép nhân chia
/// factor         → unary ( ( "/" | "*" ) unary )*
/// // Toán tử một ngôi
/// unary          → ( "!" | "-" | "--" | "++" ) unary
///                | postfix
/// postfix        → primary ("++" | "--")*
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
        stmts.add(_declaration());
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
      if (_match([TokenType.semicolon])) return;

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

  Expr _expression() => _comma();

  Expr _comma() {
    Expr expr = _assignment();

    if (_match([TokenType.comma])) {
      Token operator = _previous();
      Expr right = _assignment();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _assignment() {
    Expr expr = _conditional();

    if (_match([TokenType.equal])) {
      Token equals = _previous();
      Expr value = _assignment();

      if (expr is Variable) {
        Token name = expr.token;
        return Expr.assignment(name, value);
      }

      _error(equals, "Invalid assignment target.");
    }

    return expr;
  }

  Expr _conditional() {
    Expr expr = _equality();

    if (_match([TokenType.question])) {
      Expr thenExpr = _conditional();
      _consume(TokenType.colon, 'Expect ":" for trinary operator.');
      Expr elseExpr = _conditional();
      expr = Expr.conditional(expr, thenExpr, elseExpr);
    }

    return expr;
  }

  Expr _equality() {
    Expr expr = _comparison();

    if (_match([TokenType.bangEqual, TokenType.equalEqual])) {
      Token operator = _previous();
      Expr right = _comparison();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _comparison() {
    Expr expr = _term();

    if (_match([TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual])) {
      Token operator = _previous();
      Expr right = _term();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _term() {
    Expr expr = _factor();

    if (_match([TokenType.minus, TokenType.plus])) {
      Token operator = _previous();
      Expr right = _factor();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _factor() {
    Expr expr = _unary();

    if (_match([TokenType.slash, TokenType.star])) {
      Token operator = _previous();
      Expr right = _unary();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _unary() {
    if (_match([TokenType.minus, TokenType.minusMinus, TokenType.plus, TokenType.plusPlus])) {
      Token operator = _previous();
      Expr right = _unary();

      return Expr.unary(operator, right);
    }

    return _postfix();
  }

  Expr _postfix() {
    Expr expr = _primary();

    if (_match([TokenType.plusPlus, TokenType.minusMinus])) {
      Token operator = _previous();
      expr = Expr.postfix(expr, operator);
    }

    return expr;
  }

  Expr _primary() {
    if (_match([TokenType.number])) return Expr.literal(_previous().literal);
    if (_match([TokenType.string])) return Expr.literal(_previous().literal);
    if (_match([TokenType.kTrue])) return Expr.literal(_previous().literal);
    if (_match([TokenType.kFalse])) return Expr.literal(_previous().literal);
    if (_match([TokenType.kNil])) return Expr.literal(_previous().literal);
    if (_match([TokenType.leftBrace])) {
      Expr expr = _expression();
      _consume(TokenType.rightBrace, 'Missing ")" in group.');
      return Grouping(expr);
    }

    if (_match([TokenType.identifier])) return Expr.variable(_previous());

    throw ParserError();
  }

  Stmt _declaration() {
    try {
      if (_match([TokenType.kVar])) {
        return _varStmt();
      }
      return _statement();
    } on ParserError catch (_) {
      _synchronize();
      rethrow;
    }
  }

  Stmt _statement() {
    if (_match([TokenType.kPrint])) return _printStmt();
    return _expressionStmt();
  }

  Stmt _varStmt() {
    Token name = _consume(TokenType.identifier, 'Expect variable name.');

    Expr? initializer;

    if (_match([TokenType.equal])) {
      initializer = _expression();
    }
    _consume(TokenType.semicolon, 'Missing ";" after variable declaration.');
    return Stmt.varStmt(name, initializer);
  }

  Stmt _printStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ";" after value.');

    return Stmt.printStmt(expression);
  }

  Stmt _expressionStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ; after expression.');

    return Stmt.expressionStmt(expression);
  }
}

class ParserError extends Error {}
