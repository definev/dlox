import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/lox_function.dart';
import 'package:dlox/grammar/lox_instance.dart';
import 'package:dlox/interpreter/interpreter.dart';

class LoxClass implements LoxCallable {
  final String name;
  final Map<String, LoxFunction> _methods;

  LoxClass(this.name, this._methods);

  @override
  String toString() => name;

  @override
  int get arity {
    final initializer = _methods['init'];
    if (initializer != null) return initializer.arity;
    return 0;
  }

  @override
  call(Interpreter interpreter, List arguments) {
    LoxInstance instance = LoxInstance(this);

    _methods['init']?.bind(instance).call(interpreter, arguments);

    return instance;
  }

  LoxFunction? findMethod(String name) {
    return _methods[name];
  }
}
