import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/native.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class NativeCallScope extends Fake implements NativeCall {
  String output = "";

  @override
  String print(dynamic object) {
    output += object.toString() + "\n";
    return object.toString();
  }
}

main() {
  test('environment scope', () {
    NativeCallScope _native = NativeCallScope();
    Lox.interpreter = Interpreter(_native);

    Lox.run('''var a = "global a";
var b = "global b";
var c = "global c";
{
  var a = "outer a";
  var b = "outer b";
  {
    var a = "inner a";
    print a;
    print b;
    print c;
  }
  print a;
  print b;
  print c;
}
print a;
print b;
print c;''');

    expect(_native.output,
        equals('inner a\nouter b\nglobal c\nouter a\nouter b\nglobal c\nglobal a\nglobal b\nglobal c\n'));
  });

  // NOTE: CHAPTER 8: challenge 3
  test('override variable', () {
    NativeCallScope _native = NativeCallScope();
    Lox.interpreter = Interpreter(_native);

    Lox.run('''var a = 1;
{
  var a = a + 2;
  print a;
}''');

    expect(_native.output, equals('3\n'));
  });
}
