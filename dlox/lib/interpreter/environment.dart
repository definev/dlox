import 'dart:convert';

import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/native.dart';
import 'package:dlox/token.dart';

class Environment {
  final Environment? _enclosing;
  final Map<String, dynamic> _values;
  final Map<String, bool> _initialized;

  Environment(
      {required Map<String, dynamic> values,
      required Map<String, bool> initialized,
      Environment? enclosing})
      : _initialized = initialized,
        _values = values,
        _enclosing = enclosing;

  bool isInitialize(Token token) => _initialized[token.lexeme] ?? false;

  Environment? get enclosing => _enclosing;

  void print([int scopeLevel = 0]) {
    Native.print("SCOPE LEVEL $scopeLevel:");
    Native.print("VALUES: ${jsonEncode(_values)}");
    Native.print("INITIALIZED: ${jsonEncode(_initialized)}");
    if (_enclosing != null) {
      _enclosing!.print(scopeLevel + 1);
    }
  }

  Environment clone() {
    if (_enclosing == null) {
      return Environment(values: {..._values}, initialized: {..._initialized});
    }
    return Environment(
        values: {..._values},
        initialized: {..._initialized},
        enclosing: _enclosing!.clone());
  }

  dynamic get(Token identifier) {
    if (_enclosing == null && isInitialize(identifier) == false) {
      throw RuntimeError(
          identifier, 'variable "${identifier.lexeme}" is not initialized.');
    }
    if (isInitialize(identifier)) return _values[identifier.lexeme];
    if (_enclosing != null) return _enclosing!.get(identifier);
    throw RuntimeError(
        identifier, "Undefined variable '" + identifier.lexeme + "'.");
  }

  void define(Token identifier, dynamic value) {
    if (value == null) {
      _initialized[identifier.lexeme] = false;
      return;
    }
    _initialized[identifier.lexeme] = true;
    _values[identifier.lexeme] = value;
  }

  void assign(Token name, Object value) {
    if (_initialized.containsKey(name.lexeme)) {
      _values[name.lexeme] = value;
      _initialized[name.lexeme] = true;
      return;
    }

    if (_enclosing != null) {
      _enclosing!.assign(name, value);
      return;
    }

    throw RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }
}
