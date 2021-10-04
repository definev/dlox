import 'package:dlox/ast/ast.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/token.dart';
import 'package:dlox/token_type.dart';

class Interpreter implements Visitor<dynamic> {
  void interpretier(Expr expr) {
    try {
      final value = _evaluate(expr);
      print(_stringify(value));
    } on RuntimeError catch (e) {
      Lox.runtimeError(e);
    }
  }

  @override
  visitBinaryExpr(Binary expr) {
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
        throw RuntimeError(expr.operator, "Operands must be two numbers or two strings.");
      case TokenType.star:
        _checkNumberOperants(expr.operator, [left, right]);
        return left * right;
      case TokenType.slash:
        _checkNumberOperants(expr.operator, [left, right]);
        return left / right;
      default:
    }

    return null;
  }

  @override
  visitConditionalExpr(Conditional expr) {
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
  visitGroupingExpr(Grouping expr) {
    _evaluate(expr.expression);
  }

  @override
  visitLiteralExpr(Literal expr) {
    return expr.value;
  }

  @override
  visitUnaryExpr(Unary expr) {
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

  bool _isTruthy(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return true;
  }

  _evaluate(Expr expr) {
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
}
