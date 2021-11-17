import 'package:dlox/grammar/lox_callable.dart';
import 'package:dlox/interpreter/interpreter.dart';

class ClockFunction implements LoxCallable {
  @override
  int get arity => 0;

  @override
  call(Interpreter interpreter, List arguments) {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  String toString() {
    return 'clock<native fn>';
  }
}
