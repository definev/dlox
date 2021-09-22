import 'package:dlox/token_type.dart';

class Token {
  const Token({
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
  String toString() => '$lexeme + $literal + $line';
}
