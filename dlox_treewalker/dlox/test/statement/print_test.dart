import 'package:dlox/lox.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../fake/print_native_call.dart';

void main() {
  group('Print statement', () {
    test('String', () {
      var native = setUpFakePrint();

      Lox.run('''print "Hello world";''');
      expect(native.output, equals('Hello world\n'));
    });

    test('Number', () {
      var native = setUpFakePrint();

      Lox.run('''
      print 1;
      print -1;
      ''');
      expect(native.output, equals('1\n-1\n'));
    });

    test('Variable', () {
      var native = setUpFakePrint();

      Lox.run('''
      var whoEat = "Me";
      var pieNumber = 4;
      print whoEat;
      print pieNumber;
      ''');
      expect(native.output, equals('Me\n4\n'));
    });

    test('Compute on print', () {
      var native = setUpFakePrint();

      Lox.run('''
      print 1 + 4 + 5;
      print "Hello" + " " + "World!";
      ''');
      expect(native.output, equals('10\nHello World!\n'));
    });
  });
}
