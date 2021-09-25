import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart' as ant;

part 'expr.g.dart';

@ant.Expr([
  // "className" : "fields"
  "Binary   : Expr left, Token operator, Expr right",
  "Grouping : Expr expression",
  "Literal  : Object value",
  "Unary    : Token operator, Expr right",
])
// ignore: unused_element
class _Expr {}
