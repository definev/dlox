// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stmt.dart';

// **************************************************************************
// AstGenerator
// **************************************************************************

abstract class Stmt {
  R accept<R>(Visitor<R> visitor);
  static Stmt expressionStmt(Expr expression) => ExpressionStmt(
        expression,
      );
  static Stmt printStmt(Expr expression) => PrintStmt(
        expression,
      );
  static Stmt varStmt(Token name, Expr? initializer) => VarStmt(
        name,
        initializer,
      );
}

abstract class Visitor<R> {
  R visitExpressionStmtStmt(ExpressionStmt stmt);
  R visitPrintStmtStmt(PrintStmt stmt);
  R visitVarStmtStmt(VarStmt stmt);
}

// no docs
class ExpressionStmt extends Stmt {
  ExpressionStmt(
    this.expression,
  );

  final Expr expression;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitExpressionStmtStmt(this);
  }
}

// no docs
class PrintStmt extends Stmt {
  PrintStmt(
    this.expression,
  );

  final Expr expression;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitPrintStmtStmt(this);
  }
}

// no docs
class VarStmt extends Stmt {
  VarStmt(
    this.name,
    this.initializer,
  );

  final Token name;
  final Expr? initializer;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitVarStmtStmt(this);
  }
}
