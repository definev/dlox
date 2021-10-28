// ignore_for_file: prefer_final_fields

import 'package:dlox/grammar/lox_class.dart';
import 'package:dlox/grammar/lox_function.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/token.dart';

class LoxInstance {
  LoxInstance(this._klass);

  final LoxClass _klass;
  Map<String, dynamic> _fields = {};

  dynamic get(Token name) {
    if (_fields.keys.contains(name.lexeme)) {
      return _fields[name.lexeme];
    }

    LoxFunction? method = _klass.findMethod(name.lexeme);
    if (method != null) return method.bind(this);

    throw RuntimeError(name, 'Undefined property "${name.lexeme}".');
  }

  void set(String lexeme, dynamic value) {
    _fields[lexeme] = value;
  }

  @override
  String toString() {
    return _klass.toString() + " instance.";
  }
}
