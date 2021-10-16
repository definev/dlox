// Section 4.2.1

enum TokenType {
  /// Token đơn kí tự
  /* { */ leftBrace,
  /* } */ rightBrace,
  /* ( */ leftParen,
  /* ) */ rightParen,
  /* , */    comma,
  /* . */    dot,
  /* - -- */ minus, minusMinus,
  /* + ++ */ plus, plusPlus,
  /* ; */    semicolon, 
  /* / */    slash,
  /* * */    star,
  /* ? */    question,
  /* : */    colon,

  /// Token so sánh
  /* ! != */ bang, bangEqual,
  /* = == */ equal, equalEqual,
  /* > >= */ greater, greaterEqual,
  /* < <= */ less, lessEqual,

  /// Token kí tự
  identifier, string, number,

  /// Token từ khóa, prefix k = keyword
  kAnd, kClass, kElse, kFalse, kFun, kFor, kIf, kNil, 
  kOr, kPrint, kReturn, kSuper, kThis, kTrue, kVar, kWhile, 
  kBreak,

  eof,
}
