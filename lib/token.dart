import 'package:dlox/token_type.dart';

class Token {
  const Token(this.type, this.lexeme, this.literal, this.line);
  
  final TokenType type;
  final String lexeme;
  final Object literal;
  final int line;

  @override
  String toString() => '$lexeme + $literal + $line';
}
