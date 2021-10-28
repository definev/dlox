import 'package:dlox/lox.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  test('instance create', () {
    final native = setUpFakePrint();
    Lox.run(
        '''
    class NewClass {}

    var newInstance = NewClass();
    print newInstance;
    ''');

    expect(native.output, equals('NewClass instance.\n'));
  });
  test('init variable', () {
    final native = setUpFakePrint();
    Lox.run(
        '''
    class Vehicle {
      init(name) {
        this.name = name;
      }

      getName() {
        return this.name;
      }
    }

    var car = Vehicle("Roll Royces");
    print car.getName();
    ''');

    expect(native.output, equals('Roll Royces\n'));
  });
}
