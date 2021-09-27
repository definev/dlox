import 'dart:io';

import 'package:dlox/ast/ast.dart';
import 'package:dlox/ast/ast_printer.dart';
import 'package:dlox/ast/rpn_printer.dart';
import 'package:dlox/scanner.dart';
import 'package:dlox/token.dart';

import 'token_type.dart';

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
  Expr expression = Binary(
    Grouping(
      Binary(
        Literal(1),
        Token(type: TokenType.plus, lexeme: '+', literal: null, line: 1),
        Literal(2),
      ),
    ),
    Token(type: TokenType.star, lexeme: '*', literal: null, line: 1),
    Grouping(
      Binary(
        Literal(4),
        Token(type: TokenType.minus, lexeme: '-', literal: null, line: 1),
        Literal(3),
      ),
    ),
  );

  print(AstPrinter().print(expression));
  print(RpnPrinter().print(expression));
}
