import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/ast_generator.dart';

Builder generateAst(BuilderOptions options) =>
    SharedPartBuilder([AstGenerator()], 'ast_generator');
