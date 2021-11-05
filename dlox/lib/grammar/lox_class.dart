import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/lox_function.dart';
import 'package:dlox/grammar/lox_instance.dart';
import 'package:dlox/interpreter/interpreter.dart';

class LoxClass extends LoxInstance implements LoxCallable {
  final String name;
  final Map<String, LoxFunction> _methods;
  final LoxClass? superclass;

  LoxClass(LoxClass? metaclass, this.name, this._methods, [this.superclass])
      : super(metaclass);

  @override
  String toString() => name;

  @override
  int get arity {
    final initializer = _methods['init'];
    if (initializer != null) return initializer.arity;
    return 0;
  }

  LoxFunction? findMethod(String name) {
    if (_methods.containsKey(name)) {
      return _methods[name]!;
    }

    if (superclass != null) {
      return superclass!.findMethod(name);
    }

    return null;
  }

  @override
  call(Interpreter interpreter, List arguments) {
    LoxInstance instance = LoxInstance(this);

    LoxFunction? initializer = findMethod("init");
    if (initializer != null) {
      initializer.bind(instance).call(interpreter, arguments);
    }

    return instance;
  }
}
