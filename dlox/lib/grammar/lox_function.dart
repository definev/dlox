import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/stmt.dart';
import 'package:dlox/interpreter/environment.dart';
import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/interpreter/runtime_error.dart';

class LoxFunction implements LoxCallable {
  final FunDecl _decl;
  final Environment _closure;

  LoxFunction(this._decl, this._closure);

  @override
  int get arity => _decl.params.length;

  @override
  call(Interpreter interpreter, List arguments) {
    Environment _globals = interpreter.environment.clone();
    Environment funcScope = Environment(
      values: {},
      initialized: {},
      enclosing: _closure.clone(),
    );

    for (int i = 0; i < _decl.params.length; i++) {
      funcScope.define(_decl.params[i].lexeme, arguments[i]);
    }

    try {
      interpreter.executeBlock(_decl.body, funcScope);
    } on ReturnEvent catch (event) {
      interpreter.environment = _globals;
      return event.value;
    } on BreakEvent catch (event) {
      interpreter.environment = _globals;
      throw RuntimeError(event.keyword, 'Wrong use "break" in function.');
    }

    interpreter.environment = _globals;
    return null;
  }

  @override
  String toString() {
    return '<fn ${_decl.name.lexeme}>';
  }
}
