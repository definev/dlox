import 'package:dlox/lox.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  group('Function', () {
    test('Normal function', () {
      final native = setUpFakePrint();

      Lox.run('''
    fun helloWorld() {
      print "Hello world!!!";
    }

    helloWorld();
    ''');

      expect(native.output, equals('Hello world!!!\n'));
    });

    test('Parameters function', () {
      final native = setUpFakePrint();

      Lox.run('''
    fun sayHi(me, you) {
      print "Sweet hello from " + me + " to " + you;
    }

    sayHi("Definev_", "friends");
    ''');

      expect(native.output, equals('Sweet hello from Definev_ to friends\n'));
    });

    test('Recursive function', () {
      final native = setUpFakePrint();

      Lox.run('''
    fun fibo(n) {
      if (n <= 1) return 1;
      return fibo(n - 2) + fibo(n - 1);
    }

    print fibo(15);
    ''');

      expect(native.output, equals('987\n'));
    });
  });
}
