import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/lox_instance.dart';
import 'package:dlox/grammar/stmt.dart';
import 'package:dlox/interpreter/environment.dart';
import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/interpreter/runtime_error.dart';

class LoxFunction implements LoxCallable {
  final FunDecl _declaration;
  final Environment _closure;
  final bool _isInitializer;

  LoxFunction(this._declaration, this._closure, this._isInitializer);

  @override
  int get arity => _declaration.params.length;

  @override
  call(Interpreter interpreter, List arguments) {
    Environment funcScope = Environment(
      values: {},
      enclosing: _closure,
    );

    for (int i = 0; i < _declaration.params.length; i++) {
      funcScope.define(_declaration.params[i].lexeme, arguments[i]);
    }

    try {
      interpreter.executeBlock(_declaration.body, funcScope);
    } on ReturnEvent catch (event) {
      interpreter.environment =
          interpreter.environment.enclosing ?? interpreter.environment;
      return event.value;
    } on BreakEvent catch (event) {
      throw RuntimeError(event.keyword, 'Wrong use "break" in function.');
    }

    if (_isInitializer) return _closure.getAt(0, 'this');

    return null;
  }

  LoxFunction bind(LoxInstance instance) {
    Environment environment = Environment(values: {}, enclosing: _closure);
    environment.define('this', instance);
    return LoxFunction(_declaration, environment, _isInitializer);
  }

  @override
  String toString() {
    return '<fn ${_declaration.name.lexeme}>';
  }
}
