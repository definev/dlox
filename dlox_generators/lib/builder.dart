import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/expr_generator.dart';

Builder generateExpr(BuilderOptions options) => SharedPartBuilder([ExprGenerator()], 'expr_generator');
