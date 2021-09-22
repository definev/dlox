import 'dart:io';

import 'package:dlox/scanner.dart';
import 'package:dlox/token.dart';

class Lox {
  static bool hadError = false;

  static void main(List<String> args) {
    if (args.length > 1) {
      stdout.writeln('[Dlox] Wrong path specify.'.codeUnits);
      exit(64);
    } else if (args.length == 1) {
      runFile(args[0]);
    } else {
      runPrompt();
    }
  }

  static void run(String source) {
    Scanner scanner = Scanner(source);
    List<Token> tokens = scanner.scanTokens();

    for (final token in tokens) {
      stdout.writeln(token);
    }
  }

  static void error(int line, String message) {
    _report(line, '', message);
  }

  static void _report(int line, String where, String message) {
    stdout.writeln('[line: $line] Error: $where: $message');
    hadError = true;
  }

  static void runFile(String path) {
    File file = File(path);
    if (file.existsSync()) {
      run(file.readAsStringSync());
      if (hadError) exit(65);
    }
  }

  static void runPrompt() {
    while (true) {
      String? line = stdin.readLineSync();
      stdout.write('> ');
      if (line == null) break;
      run(line);
      hadError = false;
    }
  }
}

void main() {
  String? path = stdin.readLineSync();

  if (path != null) {
    File file = File(path);
    bool exist = file.existsSync();
    print("File exist: $exist");
    if (exist) {
      String content = file.readAsStringSync();
      // Printing the name
      print("Content: $content");
    }
  }
}
