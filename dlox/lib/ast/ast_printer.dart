import 'package:dlox/ast/expr.dart';

class AstPrinter implements Visitor<String> {
  String print(Expr expr) => expr.accept(this);

  @override
  String visitBinaryExpr(Binary expr) {
    return parenthesize(expr.operator.lexeme, [expr.left, expr.right]);
  }

  @override
  String visitGroupingExpr(Grouping expr) {
    return parenthesize('group', [expr.expression]);
  }

  @override
  String visitLiteralExpr(Literal expr) {
    if (expr.value == null) return 'nil';
    return expr.value.toString();
  }

  @override
  String visitUnaryExpr(Unary expr) {
    return parenthesize(expr.operator.lexeme, [expr.right]);
  }

  @override
  String visitConditionalExpr(Conditional expr) {
    return parenthesize('conditional', [expr.condition, expr.thenBranch, expr.elseBranch]);
  }

  String parenthesize(String name, List<Expr> exprs) {
    StringBuffer exprsBuffer = StringBuffer();

    exprsBuffer.write('($name');

    for (final expr in exprs) {
      exprsBuffer.write(' ');
      exprsBuffer.write(expr.accept(this));
    }

    exprsBuffer.write(')');

    return exprsBuffer.toString();
  }
}
