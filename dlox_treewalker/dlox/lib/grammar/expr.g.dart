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
  static Expr postfix(Expr left, Token operator) => Postfix(
        left,
        operator,
      );
  static Expr conditional(Expr condition, Expr thenBranch, Expr elseBranch) =>
      Conditional(
        condition,
        thenBranch,
        elseBranch,
      );
  static Expr variable(Token name) => Variable(
        name,
      );
  static Expr assignment(Token name, Expr value) => Assignment(
        name,
        value,
      );
  static Expr logical(Expr left, Token operator, Expr right) => Logical(
        left,
        operator,
        right,
      );
  static Expr call(Expr callee, Token paren, List<Expr> arguments) => Call(
        callee,
        paren,
        arguments,
      );
  static Expr kThis(Token keyword) => KThis(
        keyword,
      );
  static Expr get(Expr object, Token name) => Get(
        object,
        name,
      );
  static Expr set(Expr object, Token name, Expr value) => Set(
        object,
        name,
        value,
      );
  static Expr breakExpr(Token keyword) => BreakExpr(
        keyword,
      );
  static Expr kSuper(Token keyword, Token method) => KSuper(
        keyword,
        method,
      );
}

abstract class Visitor<R> {
  R visitBinaryExpr(Binary expr);
  R visitGroupingExpr(Grouping expr);
  R visitLiteralExpr(Literal expr);
  R visitUnaryExpr(Unary expr);
  R visitPostfixExpr(Postfix expr);
  R visitConditionalExpr(Conditional expr);
  R visitVariableExpr(Variable expr);
  R visitAssignmentExpr(Assignment expr);
  R visitLogicalExpr(Logical expr);
  R visitCallExpr(Call expr);
  R visitKThisExpr(KThis expr);
  R visitGetExpr(Get expr);
  R visitSetExpr(Set expr);
  R visitBreakExprExpr(BreakExpr expr);
  R visitKSuperExpr(KSuper expr);
}

// C??u l???nh c?? hai v???
// V?? d???: "a = b", "a == b", ...
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

// C??u l???nh trong d???u ngo???c "{}" "()"
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

// Gi?? tr??? numbers, strings, Booleans, and nil.
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

// To??n t??? m???t ng??i
// V?? d???: +, -, !, ...
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

// no docs
class Postfix extends Expr {
  Postfix(
    this.left,
    this.operator,
  );

  final Expr left;
  final Token operator;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitPostfixExpr(this);
  }
}

// To??n t??? ??i???u ki???n
// V?? d???: if (condition) ... else ...; condition ? ... : ...; ...
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

// no docs
class Variable extends Expr {
  Variable(
    this.name,
  );

  final Token name;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitVariableExpr(this);
  }
}

// no docs
class Assignment extends Expr {
  Assignment(
    this.name,
    this.value,
  );

  final Token name;
  final Expr value;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitAssignmentExpr(this);
  }
}

// no docs
class Logical extends Expr {
  Logical(
    this.left,
    this.operator,
    this.right,
  );

  final Expr left;
  final Token operator;
  final Expr right;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitLogicalExpr(this);
  }
}

// no docs
class Call extends Expr {
  Call(
    this.callee,
    this.paren,
    this.arguments,
  );

  final Expr callee;
  final Token paren;
  final List<Expr> arguments;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitCallExpr(this);
  }
}

// no docs
class KThis extends Expr {
  KThis(
    this.keyword,
  );

  final Token keyword;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitKThisExpr(this);
  }
}

// no docs
class Get extends Expr {
  Get(
    this.object,
    this.name,
  );

  final Expr object;
  final Token name;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitGetExpr(this);
  }
}

// no docs
class Set extends Expr {
  Set(
    this.object,
    this.name,
    this.value,
  );

  final Expr object;
  final Token name;
  final Expr value;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitSetExpr(this);
  }
}

// no docs
class BreakExpr extends Expr {
  BreakExpr(
    this.keyword,
  );

  final Token keyword;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitBreakExprExpr(this);
  }
}

// no docs
class KSuper extends Expr {
  KSuper(
    this.keyword,
    this.method,
  );

  final Token keyword;
  final Token method;

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitKSuperExpr(this);
  }
}
