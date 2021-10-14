// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stmt.dart';

// **************************************************************************
// AstGenerator
// **************************************************************************

abstract class Stmt {
  R accept<R>(Visitor<R> visitor);
  static Stmt exprStmt(Expr expression) => ExprStmt(
        expression,
      );
  static Stmt printStmt(Expr expression) => PrintStmt(
        expression,
      );
  static Stmt varStmt(Token name, Expr? initializer) => VarStmt(
        name,
        initializer,
      );
  static Stmt ifStmt(Expr condition, Stmt thenBranch, Stmt? elseBranch) =>
      IfStmt(
        condition,
        thenBranch,
        elseBranch,
      );
  static Stmt block(List<Stmt> statements) => Block(
        statements,
      );
  static Stmt whileStmt(Expr condition, Stmt body) => WhileStmt(
        condition,
        body,
      );
}

abstract class Visitor<R> {
  R visitExprStmtStmt(ExprStmt stmt);
  R visitPrintStmtStmt(PrintStmt stmt);
  R visitVarStmtStmt(VarStmt stmt);
  R visitIfStmtStmt(IfStmt stmt);
  R visitBlockStmt(Block stmt);
  R visitWhileStmtStmt(WhileStmt stmt);
}

// no docs
class ExprStmt extends Stmt {
  ExprStmt(
    this.expression,
  );

  final Expr expression;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitExprStmtStmt(this);
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

// no docs
class IfStmt extends Stmt {
  IfStmt(
    this.condition,
    this.thenBranch,
    this.elseBranch,
  );

  final Expr condition;
  final Stmt thenBranch;
  final Stmt? elseBranch;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitIfStmtStmt(this);
  }
}

// no docs
class Block extends Stmt {
  Block(
    this.statements,
  );

  final List<Stmt> statements;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitBlockStmt(this);
  }
}

// no docs
class WhileStmt extends Stmt {
  WhileStmt(
    this.condition,
    this.body,
  );

  final Expr condition;
  final Stmt body;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitWhileStmtStmt(this);
  }
}
