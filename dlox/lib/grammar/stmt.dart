import 'package:dlox/grammar/expr.dart';
import 'package:dlox/token.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'stmt.g.dart';

@Ast([
  "ExprStmt   : Expr expression",
  "ReturnStmt : Token keyword, Expr? value",
  "PrintStmt  : Expr expression",
  "VarDecl    : Token name, Expr? initializer",
  "FunDecl    : Token name, List<Token> params, List<Stmt> body",
  "ClassDecl  : Token name, Variable? superclass, List<FunDecl> methods, List<FunDecl> staticMethods",
  "IfStmt     : Expr condition, Stmt thenBranch, Stmt? elseBranch",
  "WhileStmt  : Expr condition, Stmt body",
  "Block      : List<Stmt> statements",
])
// ignore: unused_element
class _Stmt {}
