import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/_external/native.dart';
import 'package:test/fake.dart';

class NativeCallScope extends Fake implements NativeCall {
  String output = "";

  @override
  String print(dynamic object) {
    output += object.toString() + "\n";
    return object.toString();
  }
}

NativeCallScope setUpFakePrint() {
  NativeCallScope native = NativeCallScope();
  Lox.interpreter = Interpreter(native);
  return native;
}
