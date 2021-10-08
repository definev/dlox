import 'package:dlox/token.dart';

class Environment {
  final Map<String, dynamic> _values = {};

  dynamic get(Token identifier) {
    return _values[identifier.lexeme];
  }

  void define(Token identifier, dynamic value) {
    _values[identifier.lexeme] = value;
  }
}
