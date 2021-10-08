import 'package:dlox/ast/expr.dart' as expr_ast;
import 'package:dlox/ast/stmt.dart' as stmt_ast;
import 'package:dlox/interpreter/environment.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

class Interpreter implements expr_ast.Visitor<dynamic>, stmt_ast.Visitor<void> {
  final Environment _environment = Environment();

  void interpret(List<stmt_ast.Stmt> statements) {
    try {
      for (stmt_ast.Stmt statement in statements) {
        _execute(statement);
      }
    } on RuntimeError catch (error) {
      Lox.runtimeError(error);
    }
  }

  _execute(stmt_ast.Stmt statements) {
    statements.accept(this);
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
        if (left is String && right is num || left is num && right is String) {
          return '$left$right';
        }
        throw RuntimeError(expr.operator, "Operands must be two numbers or two strings.");
      case TokenType.star:
        _checkNumberOperants(expr.operator, [left, right]);
        return left * right;
      case TokenType.slash:
        _checkNumberOperants(expr.operator, [left, right]);
        if (right == 0) throw RuntimeError(expr.operator, "Cannot divided by 0.");
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
    if (condition) {
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
      default:
    }

    return null;
  }

  @override
  visitPostfixExpr(expr_ast.Postfix expr) {
    switch (expr.operator.type) {
      case TokenType.plusPlus:
        return expr.left.accept(this) + 1;
      case TokenType.minusMinus:
        return expr.left.accept(this) - 1;
      default:
        throw RuntimeError(expr.operator, 'use "${expr.operator.lexeme}" wrong type.');
    }
  }

  @override
  visitVariableExpr(expr_ast.Variable expr) {
    return _environment.get(expr.token);
  }

  @override
  visitAssignmentExpr(expr_ast.Assignment expr) {
    _environment.define(expr.name, _evaluate(expr.value));
    return _environment.get(expr.name);
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
    if (value == null) throw RuntimeError(TokenParser().kIf(-1), 'Must be bool value.');
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

  @override
  void visitExpressionStmtStmt(stmt_ast.ExpressionStmt stmt) {
    _evaluate(stmt.expression);
  }

  @override
  void visitPrintStmtStmt(stmt_ast.PrintStmt stmt) {
    print(_stringify(_evaluate(stmt.expression)));
  }

  @override
  void visitVarStmtStmt(stmt_ast.VarStmt stmt) {
    final value = _evaluate(stmt.initializer);
    _environment.define(stmt.name, value);
  }
}
