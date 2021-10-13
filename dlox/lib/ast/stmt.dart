import 'package:dlox/ast/expr.dart';
import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'stmt.g.dart';

@Ast([
  "ExpressionStmt : Expr expression",
  "PrintStmt      : Expr expression",
  "VarStmt        : Token name, Expr? initializer",
  "IfStmt         : Expr condition, Stmt thenBranch, Stmt? elseBranch",
  "Block          : List<Stmt> statements",
])
// ignore: unused_element
class _Stmt {}
