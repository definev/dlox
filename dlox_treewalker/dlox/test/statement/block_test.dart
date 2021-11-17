import 'package:dlox/lox.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

main() {
  group('Block statement', () {
    NativeCallScope native = setUpFakePrint();

    setUp(() {
      native = setUpFakePrint();
    });

    test('Nested variable', () {
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
      print c;
    ''');

      expect(
          native.output,
          equals(
              'inner a\nouter b\nglobal c\nouter a\nouter b\nglobal c\nglobal a\nglobal b\nglobal c\n'));
    });

    // NOTE: CHAPTER 8: challenge 3
    test('Override variable', () {
      Lox.run('''var a = 1;
      {
        var a = a + 2;
        print a;
      }
      ''');

      expect(
          native.output,
          equals(
              '|Resolver| [line: 3] Error : Variable "a" is not initialized yet.\n'));
    });

    test('Preceding variable', () {
      Lox.run('var a = "Outer";{print a;var a = "Inner";}');

      expect(native.output, equals('Outer\n'));
    });

    test('Error when override variable and call it-self', () {
      Lox.run('''
      var a = "inside.";
      
      {
        var a = "Dead " + a;
      }      
      ''');

      expect(
        native.output,
        equals(
            '|Resolver| [line: 4] Error : Variable "a" is not initialized yet.\n'),
      );
    });
  });
}
