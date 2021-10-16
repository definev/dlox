import 'package:dlox/grammar/expr.dart';
import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'stmt.g.dart';

@Ast([
  "ExprStmt       : Expr expression",
  "ReturnStmt     : Token keyword, Expr? value",
  "PrintStmt      : Expr expression",
  "VarDecl        : Token name, Expr? initializer",
  "FunDecl        : Token name, List<Token> params, List<Stmt> body",
  "IfStmt         : Expr condition, Stmt thenBranch, Stmt? elseBranch",
  "Block          : List<Stmt> statements",
  "WhileStmt      : Expr condition, Stmt body",
])
// ignore: unused_element
class _Stmt {}
