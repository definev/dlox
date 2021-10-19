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
    Environment funcScope = Environment(
      values: {},
      enclosing: _closure,
    );

    for (int i = 0; i < _decl.params.length; i++) {
      funcScope.define(_decl.params[i].lexeme, arguments[i]);
    }

    try {
      interpreter.executeBlock(_decl.body, funcScope);
    } on ReturnEvent catch (event) {
      interpreter.environment =
          interpreter.environment.enclosing ?? interpreter.environment;
      return event.value;
    } on BreakEvent catch (event) {
      throw RuntimeError(event.keyword, 'Wrong use "break" in function.');
    }

    return null;
  }

  @override
  String toString() {
    return '<fn ${_decl.name.lexeme}>';
  }
}
