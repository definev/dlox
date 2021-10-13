import 'package:build/build.dart';
import 'package:dlox_generators/src/token_generator.dart';
import 'package:source_gen/source_gen.dart';

import 'src/ast_generator.dart';

Builder generateExpr(BuilderOptions options) => SharedPartBuilder([AstGenerator()], 'ast_generator');

Builder generateToken(BuilderOptions options) => SharedPartBuilder([TokenGenerator()], 'token_generator');
