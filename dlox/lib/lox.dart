import 'dart:io';

import 'package:dlox/ast/ast.dart';
import 'package:dlox/ast/ast_printer.dart';
import 'package:dlox/ast/rpn_printer.dart';
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
    Expr? expression = parser.tryParse();

    if (hadError) return;

    print(AstPrinter().print(expression!));
  }

  static void parserError(Token token, String message) {
    if (token.type == TokenType.eof) {
      _report(token.line, 'at end', message);
    } else {
      _report(token.line, 'at "${token.lexeme}"', message);
    }
  }

  static void _report(int line, String where, String message) {
    stdout.writeln('[line: $line] Error: $where: $message');
    hadError = true;
  }

  static void error(int line, String message) {
    _report(line, '', message);
  }

  static void runtimeError(RuntimeError error) {
    print(error.message + "\n[line ${error.token.line}]");
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
  Expr expression = Binary(
    Literal(4),
    Token(lexeme: '>', line: 1, literal: null, type: TokenType.greater),
    Literal(3),
  );

  Lox.interpreter.interpretier(expression);
}
