// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expr.dart';

// **************************************************************************
// ExprGenerator
// **************************************************************************

abstract class Expr {
  R accept<R>(Visitor<R> visitor);
}

abstract class Visitor<R> {
  R visitBinaryExpr(Binary expr);
  R visitGroupingExpr(Grouping expr);
  R visitLiteralExpr(Literal expr);
  R visitUnaryExpr(Unary expr);
}

class Binary extends Expr {
  Binary(
    this.left,
    this.operator,
    this.right,
  );

  final Expr left;
  final Token operator;
  final Expr right;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitBinaryExpr(this);
  }
}

class Grouping extends Expr {
  Grouping(
    this.expression,
  );

  final Expr expression;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitGroupingExpr(this);
  }
}

class Literal extends Expr {
  Literal(
    this.value,
  );

  final Object value;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitLiteralExpr(this);
  }
}

class Unary extends Expr {
  Unary(
    this.operator,
    this.right,
  );

  final Token operator;
  final Expr right;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitUnaryExpr(this);
  }
}
