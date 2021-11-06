
# Lox grammar rules
Expression grammar
```json
// Biểu thức
expression     → comma ;
// Chia biểu thức qua dâu ","
comma          → assignment ("," assignment)? ;
// Đẳng thức
assignment     → (call ".")? IDENTIFIER "=" assignment 
               | conditional ;
// Toán tử ba ngôi
conditional    → logic_or ( "?" logic_or ":" logic_or )? ;
// Phép logic hoặc
logic_or       → logic_and ("or" logic_and)* ;
// Phép logic và
logic_or       → equality ("and" equality)* ;
// Đẳng thức
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
// So sách
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
// Phép cộng trừ
term           → factor ( ( "-" | "+" ) factor )* ;
// Phép nhân chia
factor         → unary ( ( "/" | "*" ) unary )* ;
// Toán tử một ngôi
unary          → ( "!" | "-" | "--" | "+" | "++" ) unary
               | postfix ;
postfix        → call ("++" | "--")* ;
call           → primary ("(" arguments? ")" | "." IDENTIFIER)* ;
arguments      → expression ( "," expression )* ;
rimary         → "true" | "false" | "nil" | "this"
               | NUMBER | STRING | IDENTIFIER | "(" expression ")"
               | "super" "." IDENTIFIER ;
```

Statement grammar
```json
program        → declaration* EOF ; 

declaration    → varDecl
               | funDecl
               | classDecl
               | statement ;

classDecl      → "class" IDENTIFIER ("<" IDENTIFIER)? "{" function* "}"    

funDecl        → "fun" function ;

function       → IDENTIFIER "(" parameters? ")" block ;

parameters     → IDENTIFIER ("," IDENTIFIER)* ;

varDecl        → "var" IDENTIFIER ("=" expression)? ";" ;

statement      → exprStmt
               | forStmt
               | ifStmt
               | printStmt 
               | returnStmt
               | breakStmt
               | whileStmt
               | block ;


returnStmt     → "return" expression? ";"
breakStmt      → "break" ";"

exprStmt       → expression ";"

whileStmt      → "while" "(" expression ")" statement ;


forStmt        → "for" "(" ( varDecl | exprStmt | ";" )
                 expression? ";"
                 expression? ")" statement ;

block          → "{" delaration* "}" ;

printStmt      → "print" expression ";" ;

ifStmt         → "if" "(" expression ")" statement 
               ( "else" statement )?;
```

Parser của Lox sẽ tiếp cận theo hướng từ trên xuống dưới.
Đệ quy đến lúc parse hết các tokens (Từ khóa) → exprs (Câu lệnh).


<b>Challenge 1 (Chapter 6):</b>
- Toán tử dấu ",".
  - Toán tử dấu "," để tách các expression.
  - Ex: "var a, b, c;", "foo(a, b, c) { ... }" ...
  - Thứ tự ưu tiên sau đẳng thức.
  - Cú pháp:
    ```
      expression → comma
      comma      → equality ("," equality)*
      equality   → ...
    ```

- Postfix "++" "--".
  - Ex: a++, b++, c--, ...
  - Độ ưu tiên cao hơn toán tử một ngôi vì trách việc parser hiểu lầm toán tử một ngôi "-" với postfix "--".
  - Cú pháp:
    ```
      unary    → ...
      postfix  → ("++" | "--")? primary;
      primary  → ...
    ```
- Prefix "++" "--".
- Giúp tách các expression.

Cú pháp của các câu lệnh (statements):
```
program        → statement* EOF
statement      → exprStmt
               | printStmt
exprStmt       → expression ";"
printStmt      → "print" expression ";"
```