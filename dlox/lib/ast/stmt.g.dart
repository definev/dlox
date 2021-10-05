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
}

abstract class Visitor<R> {
  R visitExpressionStmtStmt(ExpressionStmt stmt);
  R visitPrintStmtStmt(PrintStmt stmt);
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
