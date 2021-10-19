import 'dart:collection';

import 'package:dlox/grammar/lox_function.dart';
import 'package:dlox/grammar/native_function/clock_function.dart';
import 'package:dlox/grammar/expr.dart' as expr_ast;
import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/stmt.dart' as stmt_ast;
import 'package:dlox/interpreter/environment.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/_external/native.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

class Interpreter implements expr_ast.Visitor<dynamic>, stmt_ast.Visitor<void> {
  Interpreter([this._native = Native]);

  final NativeCall _native;
  NativeCall get native => _native;

  static Environment globals = Environment(values: {});

  Environment environment = globals;
  HashMap<expr_ast.Expr, int> locals = HashMap();

  void interpret(List<stmt_ast.Stmt> statements) {
    environment.define('clock', ClockFunction());

    try {
      for (stmt_ast.Stmt statement in statements) {
        _execute(statement);
      }
    } on RuntimeError catch (error) {
      Lox.runtimeError(error);
    }
  }

  _execute(stmt_ast.Stmt statement) {
    statement.accept(this);
  }

  void resolve(expr_ast.Expr expr, int depth) {
    locals[expr] = depth;
  }

  @override
  visitBinaryExpr(expr_ast.Binary expr) {
    final left = _evaluate(expr.left);
    final right = _evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.greater:
        _checkNumberOperants(expr.operator, [left, right]);
        return left > right;
      case TokenType.greaterEqual:
        _checkNumberOperants(expr.operator, [left, right]);
        return left >= right;
      case TokenType.less:
        _checkNumberOperants(expr.operator, [left, right]);
        return left < right;
      case TokenType.lessEqual:
        _checkNumberOperants(expr.operator, [left, right]);
        return left <= right;

      case TokenType.bangEqual:
        _checkNumberOperants(expr.operator, [left, right]);
        return !_isEqual(left, right);
      case TokenType.equalEqual:
        return _isEqual(left, right);

      case TokenType.minus:
        _checkNumberOperants(expr.operator, [left, right]);
        if (left is num && right is num) {
          return left - right;
        }
        break;
      case TokenType.plus:
        if (left is num && right is num) {
          return left + right;
        }
        if (left is String && right is String) {
          return left + right;
        }
        if ((left is String && right is num) ||
            (left is num && right is String)) {
          return '$left$right';
        }
        throw RuntimeError(
            expr.operator, "Operands must be two numbers or two strings.");
      case TokenType.star:
        _checkNumberOperants(expr.operator, [left, right]);
        return left * right;
      case TokenType.slash:
        _checkNumberOperants(expr.operator, [left, right]);
        if (right == 0) {
          throw RuntimeError(expr.operator, "Cannot divided by 0.");
        }
        return left / right;
      default:
    }

    return null;
  }

  @override
  visitConditionalExpr(expr_ast.Conditional expr) {
    final condition = _evaluate(expr.condition);
    _checkBool(condition);
    dynamic value;
    if (_isTruthy(condition)) {
      value = _evaluate(expr.thenBranch);
    } else {
      value = _evaluate(expr.elseBranch);
    }

    return value;
  }

  @override
  visitGroupingExpr(expr_ast.Grouping expr) {
    return _evaluate(expr.expression);
  }

  @override
  visitLiteralExpr(expr_ast.Literal expr) {
    return expr.value;
  }

  @override
  visitUnaryExpr(expr_ast.Unary expr) {
    final right = _evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.bang:
        return !_isTruthy(right);
      case TokenType.minus:
        _checkNumberOperant(expr.operator, right);
        return -right;
      case TokenType.plus:
        return right.toString();
      default:
    }

    return null;
  }

  @override
  visitPostfixExpr(expr_ast.Postfix expr) {
    switch (expr.operator.type) {
      case TokenType.plusPlus:
        if (expr.left is expr_ast.Variable) {
          environment.assign(
            (expr.left as expr_ast.Variable).name,
            _evaluate(expr.left) + 1,
          );
        }
        return _evaluate(expr.left);
      case TokenType.minusMinus:
        if (expr.left is expr_ast.Variable) {
          environment.assign(
            (expr.left as expr_ast.Variable).name,
            _evaluate(expr.left) - 1,
          );
        }
        return _evaluate(expr.left);
      default:
        throw RuntimeError(
            expr.operator, 'use "${expr.operator.lexeme}" wrong type.');
    }
  }

  dynamic _lookUpVariable(Token name, expr_ast.Expr expr) {
    int? distance = locals[expr];

    if (distance != null) {
      return environment.getAt(distance, name.lexeme);
    } else {
      return globals.get(name);
    }
  }

  @override
  visitVariableExpr(expr_ast.Variable expr) {
    return _lookUpVariable(expr.name, expr);
  }

  @override
  visitAssignmentExpr(expr_ast.Assignment expr) {
    int? distance = locals[expr];
    final value = _evaluate(expr.value);

    if (distance != null) {
      environment.assignAt(distance, expr.name, value);
    } else {
      globals.assign(expr.name, value);
    }
  }

  @override
  visitLogicalExpr(expr_ast.Logical expr) {
    final left = _evaluate(expr.left);
    final right = _evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.kOr:
        if (_isTruthy(left)) return left;
        if (_isTruthy(right)) return right;
        break;
      case TokenType.kAnd:
        if (_isTruthy(left) && _isTruthy(right)) return true;
        return false;
      default:
    }

    return null;
  }

  @override
  visitCallExpr(expr_ast.Call expr) {
    Environment outerEnvironment = environment;
    final callee = _evaluate(expr.callee);

    List<dynamic> arguments = [];

    for (final argument in expr.arguments) {
      arguments.add(_evaluate(argument));
    }

    if (callee is! LoxCallable) {
      throw RuntimeError(expr.paren, 'Can only call functions and classes.');
    }

    if (callee.arity != arguments.length) {
      throw RuntimeError(expr.paren,
          'Expect ${callee.arity} arguments but receive ${arguments.length}.');
    }

    final value = callee.call(this, arguments);
    environment = outerEnvironment;
    return value;
  }

  @override
  void visitBreakExprExpr(expr_ast.BreakExpr stmt) {
    throw BreakEvent(stmt.keyword);
  }

  bool _isTruthy(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return true;
  }

  _evaluate(expr_ast.Expr? expr) {
    if (expr == null) return null;
    return expr.accept(this);
  }

  bool _isEqual(dynamic left, dynamic right) {
    if (left == null && right == null) return true;
    if (left == null) return false;

    return left == right;
  }

  bool _checkNumberOperant(Token operator, dynamic right) {
    if (right is! num) {
      throw RuntimeError(operator, 'Must be a number.');
    }
    return true;
  }

  bool _checkNumberOperants(Token operator, List<dynamic> args) {
    if (args.where((opt) => opt is! num).isNotEmpty) {
      throw RuntimeError(operator, 'Must be a number.');
    }
    return true;
  }

  bool _checkBool(dynamic value) {
    if (value == null) {
      throw RuntimeError(
        Token(type: TokenType.kIf, lexeme: 'if', literal: null, line: -1),
        'Must be bool value.',
      );
    }
    return true;
  }

  String _stringify(dynamic object) {
    if (object == null) return "nil";

    if (object is double) {
      String text = object.toString();
      if (text.endsWith(".0")) {
        text = text.substring(0, text.length - 2);
      }
      return text;
    }

    return object.toString();
  }

  void executeBlock(List<stmt_ast.Stmt> statements, Environment childScope) {
    environment = childScope.clone();
    try {
      for (final statement in statements) {
        _execute(statement);
      }
    } finally {
      environment = childScope.enclosing!;
    }
  }

  @override
  void visitExprStmtStmt(stmt_ast.ExprStmt stmt) {
    _evaluate(stmt.expression);
  }

  @override
  void visitPrintStmtStmt(stmt_ast.PrintStmt stmt) {
    _native.print(_stringify(_evaluate(stmt.expression)));
  }

  @override
  void visitVarDeclStmt(stmt_ast.VarDecl stmt) {
    final value = _evaluate(stmt.initializer);
    environment.define(stmt.name.lexeme, value);
  }

  @override
  void visitBlockStmt(stmt_ast.Block stmt) {
    executeBlock(
      stmt.statements,
      Environment(values: {}, enclosing: environment),
    );
  }

  @override
  void visitIfStmtStmt(stmt_ast.IfStmt stmt) {
    if (_evaluate(stmt.condition)) {
      _execute(stmt.thenBranch);
    } else if (stmt.elseBranch != null) {
      _execute(stmt.elseBranch!);
    }
  }

  @override
  void visitWhileStmtStmt(stmt_ast.WhileStmt stmt) {
    while (_isTruthy(_evaluate(stmt.condition))) {
      try {
        _execute(stmt.body);
      } on BreakEvent catch (_) {
        break;
      }
    }
  }

  @override
  void visitFunDeclStmt(stmt_ast.FunDecl stmt) {
    final function = LoxFunction(stmt, environment);
    environment.define(stmt.name.lexeme, function);
  }

  @override
  void visitReturnStmtStmt(stmt_ast.ReturnStmt stmt) {
    dynamic value;
    if (stmt.value != null) {
      value = _evaluate(stmt.value);
    }

    throw ReturnEvent(value);
  }
}
