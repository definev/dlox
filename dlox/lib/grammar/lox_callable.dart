import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/token.dart';

abstract class LoxCallable {
  dynamic call(Interpreter interpreter, List<dynamic> arguments);

  int get arity;
}

class ReturnEvent {
  final dynamic value;

  ReturnEvent(this.value);
}

class BreakEvent {
  final Token keyword;

  BreakEvent(this.keyword);
}
