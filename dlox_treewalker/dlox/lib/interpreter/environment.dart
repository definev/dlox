import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/token.dart';

class _Unidentified {
  const _Unidentified();
}

const unidentified = _Unidentified();

class Environment {
  final Environment? _enclosing;
  final Map<String, dynamic> _values;

  Environment({required Map<String, dynamic> values, Environment? enclosing})
      : _values = values,
        _enclosing = enclosing;

  bool isInitialize(Token token) =>
      _values[token.lexeme] != unidentified &&
      _values.keys.contains(token.lexeme) == true;

  Environment? get enclosing => _enclosing;

  Environment clone() {
    if (_enclosing == null) {
      return Environment(values: {..._values});
    }
    return Environment(values: {..._values}, enclosing: _enclosing!);
  }

  dynamic get(Token identifier) {
    if (_enclosing == null && isInitialize(identifier) == false) {
      throw RuntimeError(
          identifier, 'Variable "${identifier.lexeme}" is not initialized.');
    }
    if (isInitialize(identifier)) return _values[identifier.lexeme];
    if (_enclosing != null) return _enclosing!.get(identifier);
    throw RuntimeError(
        identifier, "Undefined variable '" + identifier.lexeme + "'.");
  }

  dynamic getAt(int distance, String name) {
    return _ancestor(distance)._values[name];
  }

  Environment _ancestor(int distance) {
    Environment ancestor = clone();
    for (int i = 0; i < distance; i++) {
      ancestor = ancestor._enclosing!;
    }
    return ancestor;
  }

  void define(String identifier, dynamic value) {
    if (value == null) {
      _values[identifier] = unidentified;
    } else {
      _values[identifier] = value;
    }
  }

  void assign(Token name, dynamic value) {
    if (_values.containsKey(name.lexeme)) {
      _values[name.lexeme] = value;
      return;
    }

    if (_enclosing != null) {
      _enclosing!.assign(name, value);
      return;
    }

    throw RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }

  void assignAt(int distance, Token name, dynamic value) {
    _ancestor(distance).assign(name, value);
  }
}
