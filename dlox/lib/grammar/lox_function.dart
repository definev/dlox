import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/grammar/stmt.dart';
import 'package:dlox/interpreter/environment.dart';
import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/interpreter/runtime_error.dart';

class LoxFunction implements LoxCallable {
  final FunDecl _decl;

  LoxFunction(this._decl);

  @override
  int get arity => _decl.params.length;

  @override
  call(Interpreter interpreter, List arguments) {
    Environment funcEnv = Environment(
      values: {},
      initialized: {},
      enclosing: interpreter.environment.clone(),
    );

    for (int i = 0; i < _decl.params.length; i++) {
      funcEnv.define(_decl.params[i].lexeme, arguments[i]);
    }
    try {
      interpreter.executeBlock(_decl.body, funcEnv);
    } on ReturnEvent catch (event) {
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
