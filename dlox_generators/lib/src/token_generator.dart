import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dlox_annotations/dlox_annotations.dart';
import 'package:source_gen/source_gen.dart';

class TokenGenerator extends GeneratorForAnnotation<TokenAnnotation> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final tokenMap = annotation
        .read('tokenMap')
        .mapValue
        .map((key, value) => MapEntry(key!.toStringValue()!, value!.toStringValue()!));
    final extBuffer = StringBuffer();
    extBuffer.writeln('class TokenParser {');
    tokenMap.forEach((key, value) {
      extBuffer.writeln(
          "Token $value(int line) =>  Token(type: TokenType.$value, lexeme: '$key', literal: null, line: line);");
    });

    final literals = annotation.read('identifiers').listValue.map((e) => e.toStringValue()!);
    for (final literal in literals) {
      extBuffer.writeln(
          'Token $literal(int line, String lexeme, Object value) => Token(type: TokenType.$literal, lexeme: lexeme, literal: value, line: line);');
    }

    final keywords = annotation.read('keywords').listValue.map((e) => e.toStringValue()!).toList();
    for (final keyword in keywords) {
      extBuffer.writeln(
        'Token $keyword(int line) => Token(type: TokenType.$keyword, lexeme: \'${keyword.substring(1).toLowerCase()}\', literal: null, line: line);',
      );
    }

    extBuffer.writeln('}');
    return extBuffer.toString();
  }
}