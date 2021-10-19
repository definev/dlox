import 'package:dlox/grammar/expr.dart';
import 'package:dlox/grammar/stmt.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

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
    } on ParserError catch (e) {
      Lox.parserError(e.token, e.message);
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
    return ParserError(token, message);
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

  Expr _expression() => _assignment();

  Expr _assignment() {
    Expr expr = _conditional();

    if (_match([TokenType.equal])) {
      Token equals = _previous();
      Expr value = _assignment();

      if (expr is Variable) {
        Token name = expr.name;
        return Expr.assignment(name, value);
      }

      _error(equals, "Invalid assignment target.");
    }

    return expr;
  }

  Expr _conditional() {
    Expr expr = _logicOr();

    while (_match([TokenType.question])) {
      Expr thenExpr = _logicOr();
      _consume(TokenType.colon, 'Expect ":" for trinary operator.');
      Expr elseExpr = _logicOr();
      expr = Expr.conditional(expr, thenExpr, elseExpr);
    }

    return expr;
  }

  Expr _logicOr() {
    Expr expr = _logicAnd();

    while (_match([TokenType.kOr])) {
      Token operator = _previous();
      Expr right = _logicAnd();
      expr = Expr.logical(expr, operator, right);
    }

    return expr;
  }

  Expr _logicAnd() {
    Expr expr = _equality();

    while (_match([TokenType.kAnd])) {
      Token operator = _previous();
      Expr right = _logicAnd();
      expr = Expr.logical(expr, operator, right);
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

    while (_match([
      TokenType.greater,
      TokenType.greaterEqual,
      TokenType.less,
      TokenType.lessEqual
    ])) {
      Token operator = _previous();
      Expr right = _term();
      expr = Expr.binary(expr, operator, right);
    }

    return expr;
  }

  Expr _term() {
    Expr expr = _factor();

    while (_match([TokenType.minus, TokenType.plus])) {
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
    if (_match([
      TokenType.bang,
      TokenType.minus,
      TokenType.minusMinus,
      TokenType.plus,
      TokenType.plusPlus
    ])) {
      Token operator = _previous();
      Expr right = _unary();

      return Expr.unary(operator, right);
    }

    return _postfix();
  }

  Expr _postfix() {
    Expr expr = _call();

    if (_match([TokenType.plusPlus, TokenType.minusMinus])) {
      Token operator = _previous();
      expr = Expr.postfix(expr, operator);
    }

    return expr;
  }

  Expr _finishCall(Expr callee) {
    List<Expr> arguments = [];

    if (!_checkType(TokenType.rightParen)) {
      do {
        if (arguments.length >= 255) {
          _error(_peek(), "Can't have more than 255 arguments.");
        }
        arguments.add(_expression());
      } while (_match([TokenType.comma]));
    }

    Token paren =
        _consume(TokenType.rightParen, 'Missing ")" after arguments.');

    return Expr.call(callee, paren, arguments);
  }

  Expr _call() {
    Expr expr = _breakExpr();

    while (true) {
      if (_match([TokenType.leftParen])) {
        expr = _finishCall(expr);
      } else {
        break;
      }
    }

    return expr;
  }

  Expr _breakExpr() {
    Expr expr;
    if (_match([TokenType.kBreak])) {
      expr = Expr.breakExpr(_previous());
    } else {
      expr = _primary();
    }

    return expr;
  }

  Expr _primary() {
    if (_match([TokenType.kTrue])) return Expr.literal(true);
    if (_match([TokenType.kFalse])) return Expr.literal(false);
    if (_match([TokenType.kNil])) return Expr.literal(null);

    if (_match([TokenType.number, TokenType.string])) {
      return Expr.literal(_previous().literal);
    }

    if (_match([TokenType.leftParen])) {
      Expr expr = _expression();
      _consume(TokenType.rightParen, 'Missing ")" in group.');
      return Grouping(expr);
    }

    if (_match([TokenType.identifier])) return Expr.variable(_previous());

    throw _error(_peek(), 'Can\'t figure out what type is.');
  }

  Stmt _declaration() {
    try {
      if (_match([TokenType.kFun])) return _function('function');
      if (_match([TokenType.kVar])) return _varDecl();

      return _statement();
    } on ParserError catch (_) {
      _synchronize();
      rethrow;
    }
  }

  Stmt _function(String kind) {
    Token name = _consume(TokenType.identifier, 'Expect $kind name.');

    _consume(TokenType.leftParen, 'Expect "(" after function name.');

    List<Token> parameters = [];

    while (_checkType(TokenType.identifier)) {
      if (parameters.length >= 255) {
        _error(_peek(), "Can't have more than 255 parameters.");
        break;
      }
      parameters.add(_advance());
      if (!_match([TokenType.comma])) {
        break;
      }
    }

    _consume(TokenType.rightParen, 'Expect ")" for end function parameters.');
    _consume(TokenType.leftBrace, 'Expect "{" for block of code.');
    List<Stmt> body = _block();

    return Stmt.funDecl(name, parameters, body);
  }

  List<Stmt> _block() {
    List<Stmt> stmts = [];

    while (!_checkType(TokenType.rightBrace) && !_isAtEnd) {
      stmts.add(_declaration());
    }

    _consume(TokenType.rightBrace, 'Missing "}" at the end block of code.');

    return stmts;
  }

  Stmt _statement() {
    if (_match([TokenType.kReturn])) return _returnStmt();
    if (_match([TokenType.kWhile])) return _whileStmt();
    if (_match([TokenType.kFor])) return _forStmt();
    if (_match([TokenType.kIf])) return _ifStmt();
    if (_match([TokenType.kPrint])) return _printStmt();
    if (_match([TokenType.leftBrace])) return Stmt.block(_block());

    return _exprStmt();
  }

  Stmt _returnStmt() {
    Token keyword = _previous();
    Expr? value;

    if (!_checkType(TokenType.semicolon)) {
      value = _expression();
    }

    _consume(TokenType.semicolon, 'Missing ";" after return.');
    return Stmt.returnStmt(keyword, value);
  }

  Stmt _forStmt() {
    _consume(TokenType.leftParen, 'Missing "(" after "for" loop.');
    Stmt? initialized;
    if (_match([TokenType.kVar])) {
      initialized = _varDecl();
    } else if (!_match([TokenType.semicolon])) {
      initialized = _exprStmt();
    }

    Expr condition = Expr.literal(true);
    if (!_match([TokenType.semicolon])) {
      condition = _expression();
    }

    _consume(
        TokenType.semicolon, 'Missing ";" after condition part "for" loop.');

    Expr? increment;
    if (!_match([TokenType.rightParen])) {
      increment = _expression();
    }
    _consume(TokenType.rightParen, 'Missing ")" to end "for" loop.');

    Stmt body = _statement();

    if (increment != null) {
      body = Stmt.block([
        body,
        Stmt.exprStmt(increment),
      ]);
    }

    body = Stmt.whileStmt(condition, body);

    if (initialized != null) {
      body = Stmt.block([initialized, body]);
    }

    return body;
  }

  Stmt _whileStmt() {
    _consume(TokenType.leftParen,
        'Missing "(" for declare condition for while loop.');
    Expr condition = _expression();
    _consume(TokenType.rightParen,
        'Missing ")" for close declare condition for while loop.');
    Stmt body = _statement();
    return Stmt.whileStmt(condition, body);
  }

  Stmt _varDecl() {
    Token name = _consume(TokenType.identifier, 'Expect variable name.');

    Expr? initializer;

    if (_match([TokenType.equal])) {
      initializer = _expression();
    }
    _consume(TokenType.semicolon, 'Missing ";" after variable declaration.');
    return Stmt.varDecl(name, initializer);
  }

  Stmt _printStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ";" after value.');

    return Stmt.printStmt(expression);
  }

  Stmt _exprStmt() {
    var expression = _expression();
    _consume(TokenType.semicolon, 'Missing ; after expression.');

    return Stmt.exprStmt(expression);
  }

  Stmt _ifStmt() {
    _consume(TokenType.leftParen, 'Missing "(" after if statement.');
    Expr condition = _expression();
    _consume(TokenType.rightParen, 'Missing ")" to enclosing if statement.');
    Stmt thenBranch = _statement();
    Stmt? elseBranch;
    if (_match([TokenType.kElse])) {
      elseBranch = _statement();
    }
    return Stmt.ifStmt(condition, thenBranch, elseBranch);
  }
}

class ParserError extends Error {
  final Token token;
  final String message;

  ParserError(this.token, this.message);
}
