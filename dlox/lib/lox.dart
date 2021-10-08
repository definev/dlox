import 'dart:io';

import 'package:dlox/ast/stmt.dart';
import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/parser/parser.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/scanning/scanner.dart';
import 'package:dlox/token.dart';

import 'token_type.dart';

class Lox {
  static final Interpreter interpreter = Interpreter();

  static bool hadError = false;
  static bool hadRuntimeError = false;

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

    Parser parser = Parser(tokens);
    List<Stmt>? statements = parser.tryParse();

    if (hadError) return;

    interpreter.interpret(statements!);
  }

  static void parserError(Token token, String message) {
    if (token.type == TokenType.eof) {
      _report(token.line, 'at end', message, "PARSER");
    } else {
      _report(token.line, 'at "${token.lexeme}"', message, "PARSER");
    }
  }

  static void _report(int line, String where, String message, String from) {
    stdout.writeln('|$from| [line: $line] Error $where: $message');
    hadError = true;
  }

  static void error(int line, String message, String from) {
    _report(line, '', message, from);
  }

  static void runtimeError(RuntimeError error) {
    _report(error.token.line, '', error.message, "RUNTIME");
    hadRuntimeError = true;
  }

  static void runFile(String path) {
    File file = File(path);
    if (file.existsSync()) {
      run(file.readAsStringSync());
      if (hadError) exit(65);
      if (hadRuntimeError) exit(70);
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
  String raw = '''
var myName = "Definev_";
print myName + " handsome!";

myName = "That true!";
print myName;''';

  Lox.run(raw);
}
