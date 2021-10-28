import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'expr.g.dart';

@Ast([
// "className" : "fields"
  "Binary      : Expr left, Token operator, Expr right",
  "Grouping    : Expr expression",
  "Literal     : Object? value",
  "Unary       : Token operator, Expr right",
  "Postfix     : Expr left, Token operator",
  "Conditional : Expr condition, Expr thenBranch, Expr elseBranch",
  "Variable    : Token name",
  "Assignment  : Token name, Expr value",
  "Logical     : Expr left, Token operator, Expr right",
  "Call        : Expr callee, Token paren, List<Expr> arguments",
  "KThis       : Token keyword",
  "Get         : Expr object, Token name",
  "Set         : Expr object, Token name, Expr value",
  "BreakExpr   : Token keyword",
])
// ignore: unused_element
class _Expr {}
