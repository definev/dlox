import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dlox_annotations/dlox_annotations.dart';
import 'package:source_gen/source_gen.dart';

class ExprGenerator extends GeneratorForAnnotation<ExprAnnotation> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    StringBuffer classBuffer = StringBuffer();

    classBuffer.writeln('abstract class ');

    throw UnimplementedError();
  }
}
