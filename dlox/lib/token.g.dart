// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// TokenGenerator
// **************************************************************************

class TokenParser {
  Token leftParen(int line) =>
      Token(type: TokenType.leftParen, lexeme: '(', literal: null, line: line);
  Token rightParen(int line) =>
      Token(type: TokenType.rightParen, lexeme: ')', literal: null, line: line);
  Token leftBrace(int line) =>
      Token(type: TokenType.leftBrace, lexeme: '{', literal: null, line: line);
  Token rightBrace(int line) =>
      Token(type: TokenType.rightBrace, lexeme: '}', literal: null, line: line);
  Token comma(int line) =>
      Token(type: TokenType.comma, lexeme: ',', literal: null, line: line);
  Token dot(int line) =>
      Token(type: TokenType.dot, lexeme: '.', literal: null, line: line);
  Token minus(int line) =>
      Token(type: TokenType.minus, lexeme: '-', literal: null, line: line);
  Token plus(int line) =>
      Token(type: TokenType.plus, lexeme: '+', literal: null, line: line);
  Token semicolon(int line) =>
      Token(type: TokenType.semicolon, lexeme: ';', literal: null, line: line);
  Token slash(int line) =>
      Token(type: TokenType.slash, lexeme: '/', literal: null, line: line);
  Token star(int line) =>
      Token(type: TokenType.star, lexeme: '*', literal: null, line: line);
  Token question(int line) =>
      Token(type: TokenType.question, lexeme: '?', literal: null, line: line);
  Token colon(int line) =>
      Token(type: TokenType.colon, lexeme: ':', literal: null, line: line);
  Token bang(int line) =>
      Token(type: TokenType.bang, lexeme: '!', literal: null, line: line);
  Token bangEqual(int line) =>
      Token(type: TokenType.bangEqual, lexeme: '!=', literal: null, line: line);
  Token equal(int line) =>
      Token(type: TokenType.equal, lexeme: '=', literal: null, line: line);
  Token equalEqual(int line) => Token(
      type: TokenType.equalEqual, lexeme: '==', literal: null, line: line);
  Token greater(int line) =>
      Token(type: TokenType.greater, lexeme: '>', literal: null, line: line);
  Token greaterEqual(int line) => Token(
      type: TokenType.greaterEqual, lexeme: '>=', literal: null, line: line);
  Token less(int line) =>
      Token(type: TokenType.less, lexeme: '<', literal: null, line: line);
  Token lessEqual(int line) =>
      Token(type: TokenType.lessEqual, lexeme: '<=', literal: null, line: line);
  Token eof(int line) =>
      Token(type: TokenType.eof, lexeme: 'eof', literal: null, line: line);
  Token identifier(int line, String lexeme, Object value) => Token(
      type: TokenType.identifier, lexeme: lexeme, literal: value, line: line);
  Token string(int line, String lexeme, Object value) =>
      Token(type: TokenType.string, lexeme: lexeme, literal: value, line: line);
  Token number(int line, String lexeme, Object value) =>
      Token(type: TokenType.number, lexeme: lexeme, literal: value, line: line);
  Token kAnd(int line) =>
      Token(type: TokenType.kAnd, lexeme: 'and', literal: null, line: line);
  Token kClass(int line) =>
      Token(type: TokenType.kClass, lexeme: 'class', literal: null, line: line);
  Token kElse(int line) =>
      Token(type: TokenType.kElse, lexeme: 'else', literal: null, line: line);
  Token kFalse(int line) =>
      Token(type: TokenType.kFalse, lexeme: 'false', literal: null, line: line);
  Token kFun(int line) =>
      Token(type: TokenType.kFun, lexeme: 'fun', literal: null, line: line);
  Token kFor(int line) =>
      Token(type: TokenType.kFor, lexeme: 'for', literal: null, line: line);
  Token kIf(int line) =>
      Token(type: TokenType.kIf, lexeme: 'if', literal: null, line: line);
  Token kNil(int line) =>
      Token(type: TokenType.kNil, lexeme: 'nil', literal: null, line: line);
  Token kOr(int line) =>
      Token(type: TokenType.kOr, lexeme: 'or', literal: null, line: line);
  Token kPrint(int line) =>
      Token(type: TokenType.kPrint, lexeme: 'print', literal: null, line: line);
  Token kReturn(int line) => Token(
      type: TokenType.kReturn, lexeme: 'return', literal: null, line: line);
  Token kSuper(int line) =>
      Token(type: TokenType.kSuper, lexeme: 'super', literal: null, line: line);
  Token kThis(int line) =>
      Token(type: TokenType.kThis, lexeme: 'this', literal: null, line: line);
  Token kTrue(int line) =>
      Token(type: TokenType.kTrue, lexeme: 'true', literal: null, line: line);
  Token kVar(int line) =>
      Token(type: TokenType.kVar, lexeme: 'var', literal: null, line: line);
  Token kWhile(int line) =>
      Token(type: TokenType.kWhile, lexeme: 'while', literal: null, line: line);
}
