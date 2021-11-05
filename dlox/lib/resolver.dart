// ignore_for_file: prefer_final_fields

import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/token.dart';

import 'grammar/expr.dart' as expr_ast;
import 'grammar/stmt.dart' as stmt_ast;

typedef Scope = Map<String, bool>;

enum FunctionType { none, function, init, method }

enum ClassType { none, kClass, subClass }

class Resolver implements expr_ast.Visitor<void>, stmt_ast.Visitor<void> {
  Resolver(this.interpreter);

  final Interpreter interpreter;
  List<Scope> _scopes = [];
  FunctionType _currentFunction = FunctionType.none;
  ClassType _currentClass = ClassType.none;

  void _beginScope() => _scopes.add({});

  void _endScope() => _scopes.removeLast();

  void _resolveStmt(stmt_ast.Stmt statement) {
    statement.accept(this);
  }

  void _resolveExpr(expr_ast.Expr expression) {
    expression.accept(this);
  }

  void resolves(List<stmt_ast.Stmt> statments) {
    for (final statement in statments) {
      _resolveStmt(statement);
    }
  }

  void _declare(Token token) {
    if (_scopes.isEmpty) return;
    var scope = _scopes.last;
    if (scope.containsKey(token.lexeme)) {
      Lox.error(
        token.line,
        'Already define variable "${token.lexeme}" in this scope.',
        'resolver',
      );
    }
    scope[token.lexeme] = false;
    _scopes.last = scope;
  }

  void _define(Token token) {
    if (_scopes.isEmpty) return;
    var scope = _scopes.last;
    scope[token.lexeme] = true;
    _scopes.last = scope;
  }

  void _resolveFunction(stmt_ast.FunDecl function, FunctionType type) {
    FunctionType enclosingFunction = _currentFunction;
    _currentFunction = type;
    _beginScope();
    for (Token param in function.params) {
      _declare(param);
      _define(param);
    }
    resolves(function.body);
    _endScope();
    _currentFunction = enclosingFunction;
  }

  @override
  void visitAssignmentExpr(expr_ast.Assignment expr) {
    _resolveExpr(expr.value);
    _resolveLocal(expr, expr.name);
  }

  @override
  void visitBinaryExpr(expr_ast.Binary expr) {
    _resolveExpr(expr.left);
    _resolveExpr(expr.right);
  }

  @override
  void visitBlockStmt(stmt_ast.Block stmt) {
    _beginScope();
    resolves(stmt.statements);
    _endScope();
  }

  @override
  void visitBreakExprExpr(expr_ast.BreakExpr expr) {}

  @override
  void visitCallExpr(expr_ast.Call expr) {
    _resolveExpr(expr.callee);

    for (final arg in expr.arguments) {
      _resolveExpr(arg);
    }
  }

  @override
  void visitConditionalExpr(expr_ast.Conditional expr) {
    _resolveExpr(expr.condition);
    _resolveExpr(expr.thenBranch);
    _resolveExpr(expr.elseBranch);
  }

  @override
  void visitExprStmtStmt(stmt_ast.ExprStmt stmt) {
    _resolveExpr(stmt.expression);
  }

  @override
  void visitFunDeclStmt(stmt_ast.FunDecl stmt) {
    _declare(stmt.name);
    _define(stmt.name);
    _resolveFunction(stmt, FunctionType.function);
  }

  @override
  void visitGroupingExpr(expr_ast.Grouping expr) {
    _resolveExpr(expr.expression);
  }

  @override
  void visitIfStmtStmt(stmt_ast.IfStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.thenBranch);
    if (stmt.elseBranch != null) _resolveStmt(stmt.elseBranch!);
  }

  @override
  void visitLiteralExpr(expr_ast.Literal expr) {}

  @override
  void visitLogicalExpr(expr_ast.Logical expr) {
    _resolveExpr(expr.left);
    _resolveExpr(expr.right);
  }

  @override
  void visitPostfixExpr(expr_ast.Postfix expr) {
    _resolveExpr(expr.left);
  }

  @override
  void visitPrintStmtStmt(stmt_ast.PrintStmt stmt) {
    _resolveExpr(stmt.expression);
  }

  @override
  void visitReturnStmtStmt(stmt_ast.ReturnStmt stmt) {
    if (_currentFunction == FunctionType.none) {
      Lox.error(
        stmt.keyword.line,
        'Can\'t return in top-level code.',
        'resolver',
      );
    }

    if (stmt.value != null) {
      if (_currentFunction == FunctionType.init) {
        Lox.error(
          stmt.keyword.line,
          'Can\'t return in init method.',
          'resolver',
        );
      }
      _resolveExpr(stmt.value!);
    }
  }

  @override
  void visitUnaryExpr(expr_ast.Unary expr) {
    _resolveExpr(expr.right);
  }

  @override
  void visitVarDeclStmt(stmt_ast.VarDecl stmt) {
    _declare(stmt.name);
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer!);
    }
    _define(stmt.name);
  }

  void _resolveLocal(expr_ast.Expr expr, Token name) {
    for (int i = _scopes.length - 1; i >= 0; i--) {
      if (_scopes[i][name.lexeme] == true) {
        interpreter.resolve(expr, _scopes.length - 1 - i);
        return;
      }
    }
  }

  @override
  void visitVariableExpr(expr_ast.Variable expr) {
    if (_scopes.isNotEmpty && _scopes.last[expr.name.lexeme] == false) {
      Lox.error(
        expr.name.line,
        'Variable "${expr.name.lexeme}" is not initialized yet.',
        'Resolver',
      );
    }

    _resolveLocal(expr, expr.name);
  }

  @override
  void visitGetExpr(expr_ast.Get expr) {
    _resolveExpr(expr.object);
  }

  @override
  void visitWhileStmtStmt(stmt_ast.WhileStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.body);
  }

  @override
  void visitClassDeclStmt(stmt_ast.ClassDecl stmt) {
    final _enclosingClass = _currentClass;
    _currentClass = ClassType.kClass;
    _declare(stmt.name);

    if (stmt.superclass != null &&
        stmt.superclass!.name.lexeme == stmt.name.lexeme) {
      Lox.error(
        stmt.name.line,
        'A class cannot inherit from itself.',
        'resolver',
      );
    }

    if (stmt.superclass != null) {
      _currentClass = ClassType.subClass;
      _resolveExpr(stmt.superclass!);
    }

    if (stmt.superclass != null) {
      _beginScope();
      _scopes[_scopes.length - 1]["super"] = true;
    }

    _beginScope();
    _scopes[_scopes.length - 1]["this"] = true;

    for (final method in stmt.methods) {
      FunctionType declaration = FunctionType.method;
      if (method.name.lexeme == 'init') {
        declaration = FunctionType.init;
      }
      _resolveFunction(method, declaration);
    }

    _define(stmt.name);
    _endScope();

    if (stmt.superclass != null) _endScope();

    for (final method in stmt.staticMethods) {
      _beginScope();

      _scopes[_scopes.length - 1]["this"] = true;
      _resolveFunction(method, FunctionType.method);
      _endScope();
    }

    _currentClass = _enclosingClass;
  }

  @override
  void visitSetExpr(expr_ast.Set expr) {
    _resolveExpr(expr.value);
    _resolveExpr(expr.object);
  }

  @override
  void visitKThisExpr(expr_ast.KThis expr) {
    if (_currentClass == ClassType.none) {
      Lox.error(
        expr.keyword.line,
        'Cannot use "this" in outside class scope.',
        'resolver',
      );
      return;
    }
    _resolveLocal(expr, expr.keyword);
  }

  @override
  void visitKSuperExpr(expr_ast.KSuper expr) {
    _resolveLocal(expr, expr.keyword);
    if (_currentClass == ClassType.none) {
      Lox.error(
        expr.keyword.line,
        'Can\'t use "super" outside of a class.',
        'resolve',
      );
    } else if (_currentClass != ClassType.subClass) {
      Lox.error(
        expr.keyword.line,
        'Can\'t use "super" in a class with no superclass.',
        'resolve',
      );
    }
  }
}
