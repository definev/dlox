import 'package:dlox/lox.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  group('If statement', () {
    test('Condition: true', () {
      var native = setUpFakePrint();

      Lox.run('if (true) print "Success!";');

      expect(native.output, equals('Success!\n'));
    });

    test('Condition: false no else statement', () {
      var native = setUpFakePrint();

      Lox.run('if (false) print "Success!";');

      expect(native.output, equals(''));
    });

    test('Condition: false with else statement', () {
      var native = setUpFakePrint();

      Lox.run(
          '''
      if (false) 
        print "Failed!";
      else
        print "Success!"; 
      ''');

      expect(native.output, equals('Success!\n'));
    });

    test('Nested if-else', () {
      var native = setUpFakePrint();

      Lox.run(
          '''
      var a = 1;
      if (a == 0) {
        print "Failed!";
      } else if (a == 1) {
        print "Success!";
      } 
      ''');

      expect(native.output, equals('Success!\n'));
    });
  });
}
