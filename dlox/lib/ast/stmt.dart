import 'package:dlox/ast/expr.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'stmt.g.dart';

@Ast([
  "ExpressionStmt : Expr expression",
  "PrintStmt      : Expr expression",
])
// ignore: unused_element
class _Stmt {}
