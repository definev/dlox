import 'package:dlox/lox.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  group('Function', () {
    NativeCallScope native = setUpFakePrint();
    setUp(() {
      native = setUpFakePrint();
    });

    test('Normal function', () {
      Lox.run('''
    fun helloWorld() {
      print "Hello world!!!";
    }

    helloWorld();
    ''');

      expect(native.output, equals('Hello world!!!\n'));
    });

    test('Parameters function', () {
      Lox.run('''
    fun sayHi(me, you) {
      print "Sweet hello from " + me + " to " + you;
    }

    sayHi("Definev_", "friends");
    ''');

      expect(native.output, equals('Sweet hello from Definev_ to friends\n'));
    });

    test('Recursive function', () {
      Lox.run('''
    fun fibo(n) {
      if (n <= 1) return 1;
      return fibo(n - 2) + fibo(n - 1);
    }

    print fibo(15);
    ''');

      expect(native.output, equals('987\n'));
    });

    test('Closures function', () {
      Lox.run('''
    fun counting(initValue) {
      var index = initValue;
      fun adding() {
        index++;
        print index;
      }

      return adding;
    }

    var counter = counting(0);
    counter();
    counter();
    ''');

      expect(native.output, equals('1\n2\n'));
    });

    test('Error when return at top-level code', () {
      Lox.run('return "at the top-level code.";');
      expect(
        native.output,
        equals(
            '|resolver| [line: 1] Error : Can\'t return in top-level code.\n'),
      );
    });
  });
}
