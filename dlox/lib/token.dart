import 'package:dlox/token_type.dart';

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
