import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'expr.g.dart';

@Ast([
  // "className" : "fields"
  "Binary         : Expr left, Token operator, Expr right",
  "Grouping       : Expr expression",
  "Literal        : Object? value",
  "Unary          : Token operator, Expr right",
  "Postfix        : Expr left, Token operator",
  "Conditional    : Expr condition, Expr thenBranch, Expr elseBranch",
  "Variable       : Token token",
  "Assignment     : Token name, Expr value",
])
// ignore: unused_element
class _Expr {}



