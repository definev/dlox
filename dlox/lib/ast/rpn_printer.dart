import 'package:dlox/ast/ast.dart';
import 'package:dlox/token.dart';

class RpnPrinter implements Visitor<String> {
  String print(Expr expr) => expr.accept(this);

  @override
  String visitBinaryExpr(Binary expr) {
    return _rpnPrint([expr.left, expr.right], expr.operator);
  }

  @override
  String visitGroupingExpr(Grouping expr) {
    return _rpnPrint([expr.expression]);
  }

  @override
  String visitLiteralExpr(Literal expr) {
    if (expr.value == null) return 'nil';
    return expr.value.toString();
  }

  @override
  String visitUnaryExpr(Unary expr) {
    return _rpnPrint([expr.right], expr.operator);
  }

  String _rpnPrint(List<Expr> exprs, [Token? token]) {
    StringBuffer printBuffer = StringBuffer();

    for (final expr in exprs) {
      printBuffer.write('${expr.accept(this)} ');
    }

    if (token != null) printBuffer.write(token.lexeme);
    return printBuffer.toString().trim();
  }
}