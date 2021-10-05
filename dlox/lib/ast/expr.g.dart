// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expr.dart';

// **************************************************************************
// AstGenerator
// **************************************************************************

abstract class Expr {
  R accept<R>(Visitor<R> visitor);
  static Expr binary(Expr left, Token operator, Expr right) => Binary(
        left,
        operator,
        right,
      );
  static Expr grouping(Expr expression) => Grouping(
        expression,
      );
  static Expr literal(Object? value) => Literal(
        value,
      );
  static Expr unary(Token operator, Expr right) => Unary(
        operator,
        right,
      );
  static Expr conditional(Expr condition, Expr thenBranch, Expr elseBranch) =>
      Conditional(
        condition,
        thenBranch,
        elseBranch,
      );
}

abstract class Visitor<R> {
  R visitBinaryExpr(Binary expr);
  R visitGroupingExpr(Grouping expr);
  R visitLiteralExpr(Literal expr);
  R visitUnaryExpr(Unary expr);
  R visitConditionalExpr(Conditional expr);
}

// Câu lệnh có hai vế
// Ví dụ: "a = b", "a == b", ...
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

// Câu lệnh trong dấu ngoặc "{}" "()"
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

// Giá trị numbers, strings, Booleans, and nil.
class Literal extends Expr {
  Literal(
    this.value,
  );

  final Object? value;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitLiteralExpr(this);
  }
}

// Toán tử một ngôi
// Ví dụ: +, -, !, ...
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

// Toán tử điều kiện
// Ví dụ: if (condition) ... else ...; condition ? ... : ...; ...
class Conditional extends Expr {
  Conditional(
    this.condition,
    this.thenBranch,
    this.elseBranch,
  );

  final Expr condition;
  final Expr thenBranch;
  final Expr elseBranch;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitConditionalExpr(this);
  }
}
