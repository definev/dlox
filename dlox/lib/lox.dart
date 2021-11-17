import 'dart:io';

import 'package:dlox/grammar/stmt.dart';
import 'package:dlox/interpreter/interpreter.dart';
import 'package:dlox/parser.dart';
import 'package:dlox/interpreter/runtime_error.dart';
import 'package:dlox/resolver.dart';
import 'package:dlox/scanner.dart';
import 'package:dlox/token.dart';

import 'token_type.dart';

class Lox {
  static Interpreter interpreter = Interpreter();

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

    Resolver resolver = Resolver(interpreter);
    resolver.resolves(statements!);

    if (hadError) return;

    interpreter.interpret(statements);
  }

  static void parserError(Token token, String message) {
    if (token.type == TokenType.eof) {
      _report(token.line, 'at end', message, "PARSER");
    } else {
      _report(token.line, 'at "${token.lexeme}"', message, "PARSER");
    }
  }

  static void _report(int line, String where, String message, String from) {
    interpreter.native.print('|$from| [line: $line] Error $where: $message');
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
      stdout.write('> ');
      String? line = stdin.readLineSync();
      if (line == null) break;
      run(line);
      hadError = false;
    }
  }
}

void main() {
  Lox.run('''
  fun fib(n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}

var before = clock();
print fib(25);
var after = clock();
var time = after - before;
print "TOTAL CALULATE MS: " + time;
''');
}
