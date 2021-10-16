import 'package:dlox/token_type.dart';
import 'package:dlox_annotations/dlox_annotations.dart';

part 'token.g.dart';

@TokenAnnotation(tokenMap: {
  "(": "leftParen",
  ")": "rightParen",
  "{": "leftBrace",
  "}": "rightBrace",
  ",": "comma",
  ".": "dot",
  "-": "minus",
  "+": "plus",
  ";": "semicolon",
  "/": "slash",
  "*": "star",
  "?": "question",
  ":": "colon",
  "!": "bang",
  "!=": "bangEqual",
  "=": "equal",
  "==": "equalEqual",
  ">": "greater",
  ">=": "greaterEqual",
  "<": "less",
  "<=": "lessEqual",
  "eof": "eof",
}, identifiers: [
  "identifier",
  "string",
  "number"
], keywords: [
  "kAnd",
  "kClass",
  "kElse",
  "kFalse",
  "kFun",
  "kFor",
  "kIf",
  "kNil",
  "kOr",
  "kPrint",
  "kReturn",
  "kSuper",
  "kThis",
  "kTrue",
  "kVar",
  "kWhile",
])
class Token {
  Token({
    required this.type,
    required this.lexeme,
    required this.literal,
    required this.line,
  });

  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line;

  @override
  String toString() {
    return 'type: $type | lexeme: "$lexeme" | literal: "$literal"';
  }
}
