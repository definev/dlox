import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dlox_annotations/dlox_annotations.dart';
import 'package:source_gen/source_gen.dart';

Map<String, String> instructions = {
  'Binary': '// Câu lệnh có hai vế \n// Ví dụ: "a = b", "a == b", ...',
  'Grouping': '// Câu lệnh trong dấu ngoặc "{}" "()"',
  'Literal': '// Giá trị numbers, strings, Booleans, and nil.',
  'Unary': '// Toán tử một ngôi\n// Ví dụ: +, -, !, ...',
  'Conditional': '// Toán tử điều kiện\n// Ví dụ: if (condition) ... else ...; condition ? ... : ...; ...',
};

class AstGenerator extends GeneratorForAnnotation<Ast> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final baseClassName = element.displayName.substring(1);

    StringBuffer classBuffer = StringBuffer();

    final ant = element.metadata.first;
    final fields = ant.computeConstantValue()!.getField('fields')!.toListValue();
    final fieldList = fields!.map((value) => value.toStringValue() ?? ':').toList();

    classBuffer.writeln('abstract class $baseClassName {');
    classBuffer.writeln('R accept<R>(Visitor<R> visitor);');

    fieldList.forEach((line) {
      final className = line.split(':')[0].trim();
      final fieldListRaw = line.split(':')[1].trim();
      final fieldList = fieldListRaw.split(', ');
      final constructor = fieldList.fold<String>(
        '',
        (prev, current) => prev + current.split(' ')[1] + ",",
      );

      classBuffer.writeln(
          'static $baseClassName ${className[0].toLowerCase() + className.substring(1)}(${fieldListRaw}) => $className($constructor);');
    });

    classBuffer.writeln('}');

    generateVisitor(classBuffer, baseClassName, fieldList.map((field) => field.split(':')[0].trim()).toList());

    fieldList.forEach((line) {
      final className = line.split(':')[0].trim();
      final fieldList = line.split(':')[1].trim();

      generateSubClass(classBuffer, baseClassName, className, fieldList);
    });

    return classBuffer.toString();
  }
}

void generateSubClass(StringBuffer classBuffer, String baseClassName, String className, String fields) {
  classBuffer.writeln(instructions[className] ?? '// no docs');
  classBuffer.writeln('class $className extends $baseClassName {');

  classBuffer.writeln('$className(');
  final fieldList = fields.split(', ');
  for (final field in fieldList) {
    String name = field.split(' ')[1];
    classBuffer.writeln('this.$name,');
  }
  classBuffer.writeln(');');

  classBuffer.writeln();

  for (final field in fieldList) {
    String type = field.split(' ')[0];
    String name = field.split(' ')[1];
    classBuffer.writeln('final $type $name;');
  }

  classBuffer.writeln();

  classBuffer.writeln('@override');
  classBuffer.writeln('R accept<R>(Visitor<R> visitor) {');
  classBuffer.writeln('return visitor.visit$className$baseClassName(this);');
  classBuffer.writeln('}');

  classBuffer.writeln('}');
}

void generateVisitor(StringBuffer classBuffer, String baseClassName, List<String> types) {
  classBuffer.writeln('abstract class Visitor<R> {');
  types.forEach((type) {
    classBuffer.writeln('R visit$type$baseClassName($type ${baseClassName.toLowerCase()});');
  });
  classBuffer.writeln('}');
}
