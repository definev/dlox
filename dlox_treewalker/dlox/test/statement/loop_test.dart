import 'package:dlox/lox.dart';
import 'package:test/test.dart';

import '../fake/print_native_call.dart';

void main() {
  group('Loop test', () {
    test(
      'While loop',
      () {
        var native = setUpFakePrint();
        Lox.run(
            '''
        var loop = 0;
        while (loop < 10) {
          print loop;
          loop++;
        }
        ''');
        expect(
          native.output,
          equals(List.generate(10, (index) => '$index\n')
              .fold<String>('', (prev, cur) => prev + cur)),
        );
      },
    );
    test(
      'For loop',
      () {
        var native = setUpFakePrint();
        Lox.run(
            '''
        for (var loop = 0;loop < 10; loop++) {
          print loop;
        }
        ''');
        expect(
          native.output,
          equals(List.generate(10, (index) => '$index\n')
              .fold<String>('', (prev, cur) => prev + cur)),
        );
      },
    );
  });
}
