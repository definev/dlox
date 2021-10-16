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
  static Stmt returnStmt(Token keyword, Expr? value) => ReturnStmt(
        keyword,
        value,
      );
  static Stmt printStmt(Expr expression) => PrintStmt(
        expression,
      );
  static Stmt varDecl(Token name, Expr? initializer) => VarDecl(
        name,
        initializer,
      );
  static Stmt funDecl(Token name, List<Token> params, List<Stmt> body) =>
      FunDecl(
        name,
        params,
        body,
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
  R visitReturnStmtStmt(ReturnStmt stmt);
  R visitPrintStmtStmt(PrintStmt stmt);
  R visitVarDeclStmt(VarDecl stmt);
  R visitFunDeclStmt(FunDecl stmt);
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
class ReturnStmt extends Stmt {
  ReturnStmt(
    this.keyword,
    this.value,
  );

  final Token keyword;
  final Expr? value;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitReturnStmtStmt(this);
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
class VarDecl extends Stmt {
  VarDecl(
    this.name,
    this.initializer,
  );

  final Token name;
  final Expr? initializer;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitVarDeclStmt(this);
  }
}

// no docs
class FunDecl extends Stmt {
  FunDecl(
    this.name,
    this.params,
    this.body,
  );

  final Token name;
  final List<Token> params;
  final List<Stmt> body;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitFunDeclStmt(this);
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
