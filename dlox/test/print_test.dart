import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/lox.dart';
import 'package:dlox/native.dart';
import 'package:test/expect.dart';
import 'package:test/fake.dart';
import 'package:test/scaffolding.dart';

class NativeCallScope extends Fake implements NativeCall {
  String output = "";

  @override
  String print(dynamic object) {
    output += object.toString() + "\n";
    return object.toString();
  }
}

void main() {
  group('Print primative type', () {
    test('String', () {
      NativeCallScope native = NativeCallScope();
      Lox.interpreter = Interpreter(native);

      Lox.run('''print "Hello world";''');
      expect(native.output, equals('Hello world\n'));
    });

    test('Number', () {
      NativeCallScope native = NativeCallScope();
      Lox.interpreter = Interpreter(native);

      Lox.run('''
      print 1;
      print -1;
      ''');
      expect(native.output, equals('1\n-1\n'));
    });
  });

  test('Variable', () {
    NativeCallScope native = NativeCallScope();
    Lox.interpreter = Interpreter(native);

    Lox.run('''
      var whoEat = "Me";
      var pieNumber = 4;
      print whoEat;
      print pieNumber;
      ''');
    expect(native.output, equals('Me\n4\n'));
  });
}
