import 'package:dlox/lox.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  test('instance create', () {
    final native = setUpFakePrint();
    Lox.run('''
    class NewClass {}

    var newInstance = NewClass();
    print newInstance;
    ''');

    expect(native.output, equals('NewClass instance.\n'));
  });
  test('init function call', () {
    final native = setUpFakePrint();
    Lox.run('''
    class Vehicle {
      init(name) {
        print "Vehicle " + name;
      }
    }

    var car = Vehicle("Roll Royces");
    ''');

    expect(native.output, equals('Vehicle Roll Royces\n'));
  });
  test('Call method', () {
    final native = setUpFakePrint();
    Lox.run('''
    class Math {
      square(n) {
        return n * n;
      }
    }

    var squareOfTwo = Math().square(2);
    print squareOfTwo;
    ''');

    expect(native.output, equals('4\n'));
  });
  test('Static method', () {
    final native = setUpFakePrint();
    Lox.run('''
    class Math {
      class square(n) {
        return n * n;
      }
    }

    print Math.square(3); // Prints "9".
    ''');

    expect(native.output, equals('9\n'));
  });
}
