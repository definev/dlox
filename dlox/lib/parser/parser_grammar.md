
# Parser grammar rules
Expression grammar
```js
// Biểu thức
expression     → comma
// Chia biểu thức qua dâu ","
comma          → assignment ("," assignment)?
// Đẳng thức
assignment     → IDENTIFIER "=" assignment 
               | conditional
// Toán tử ba ngôi
conditional    → equality ( "?" conditional ":" conditional )?
// Đẳng thức
equality       → comparison ( ( "!=" | "==" ) comparison )*
// So sách
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )*
// Phép cộng trừ
term           → factor ( ( "-" | "+" ) factor )*
// Phép nhân chia
factor         → unary ( ( "/" | "*" ) unary )*
// Toán tử một ngôi
unary          → ( "!" | "-" | "--" | "+" | "++" ) unary
               | postfix
postfix        → primary ("++" | "--")*
primary        → NUMBER | STRING | "true" | "false" | "nil"
               | "(" expression ")"
```

Statement grammar
```js
program        → declaration* EOF 

declaration    → varDecl
               | statement

block          → "{" delaration* "}"

varDecl        → "var" IDENTIFIER ("=" expression)? ";"

statement      → exprStmt
               | printStmt 
               | ifStmt
               | block

printStmt      → "print" expression ";"

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