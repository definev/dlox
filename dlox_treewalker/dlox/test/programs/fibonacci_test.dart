import 'package:dlox/lox.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  test('Fibonacci', () {
    var native = setUpFakePrint();
    Lox.run('''var a = 0;
var temp;

for (var b = 1; a < 10000; b = temp + b) {
  temp = a;
  a = b;
}
print a;''');

    expect(native.output, equals('10946\n'));
  });
}
