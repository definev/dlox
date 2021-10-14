import 'package:dlox/ast/expr.dart';
import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'stmt.g.dart';

@Ast([
  "ExprStmt       : Expr expression",
  "PrintStmt      : Expr expression",
  "VarStmt        : Token name, Expr? initializer",
  "IfStmt         : Expr condition, Stmt thenBranch, Stmt? elseBranch",
  "Block          : List<Stmt> statements",
  "WhileStmt      : Expr condition, Stmt body",
])
// ignore: unused_element
class _Stmt {}
