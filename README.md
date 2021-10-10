# Dlox
Hiện tại tôi đang đọc cuốn `Crafting Interpreters` của Robert Nystrom. Một cuốn sách rất hay cho những ai đang tìm hiểu về trình thông dịch. Project này thực hiện trong quá trình port ngôn ngữ lox được viết bằng Java và C trong cuốn sách sang Dart. Từng commit tương ứng với từng chương, bạn có thể xem và cùng làm theo.


## A TREE-WALK INTERPRETER

- [x] 4.  [**Scanning**](http://www.craftinginterpreters.com/scanning.html) - [Lox Interpreter in Swift](http://alejandromp.com/blog/2017/1/30/lox-interpreter-in-swift/)
  - [x] Challenge 4: C-style /* ... */ block comments.

- [x] 5.  [**Representing Code**](http://www.craftinginterpreters.com/representing-code.html)
  - [x] Challenge 3: AST Printer In Reverse Polish Notation.
  - [x] GenerateAst tool

- [x] 6. [**Parsing Expressions**](http://www.craftinginterpreters.com/parsing-expressions.html) 
  - [x] Helper method for parsing left-associative series of binary operators. *Swift can't pass variadic arguments between functions (no array splatting), so it's a little bit hugly.*
  - [x] Challenge 1: Add prefix and postfix ++ and -- operators.
  - [x] Challenge 2: Add support for the C-style conditional or “ternary” operator `?:`
  - [x] Challenge 3: Add error productions to handle each binary operator appearing without a left-hand operand.

- [x] 7. [**Evaluating Expressions**](http://www.craftinginterpreters.com/evaluating-expressions.html)
  - [x] Challenge 1: Allowing comparisons on types other than numbers could be useful.
  - [x] Challenge 2: Many languages define + such that if either operand is a string, the other is converted to a string and the results are then concatenated.
  - [x] Challenge 3: Change the implementation in visitBinary() to detect and report a runtime error when dividing by 0. 

- [ ] 8. [**Statements and State**](http://www.craftinginterpreters.com/statements-and-state.html)
  - [ ] Challenge 1: Add support to the REPL to let users type in both statements and expressions.
  - [x] Challenge 2: Make it a runtime error to access a variable that has not been initialized or assigned to
  - Challenge 3: Nothing to implement.

- [ ] 9. [**Control Flow**](http://www.craftinginterpreters.com/control-flow.html)
  - [ ] Challenge 1: Nothing to implement.
  - [ ] Challenge 2: Nothing to implement.
  - [ ] Challenge 3: Add support for break statements.

- [ ] 10. [**Functions**](http://www.craftinginterpreters.com/functions.html)
  - [ ] Challenge 1: Nothing to implement.
  - [ ] Challenge 2: Add anonymous function (lambdas) syntax.
  - [ ] Challenge 3: Nothing to implement.

- [ ] 11. [**Resolving and Binding**](http://www.craftinginterpreters.com/resolving-and-binding.html)
  - [ ] Challenge 1: Nothing to implement.
  - [ ] Challenge 2: Nothing to implement.
  - [ ] Challenge 3: Extend the resolver to report an error if a local variable is never used.
  - [ ] Challenge 4: Store local variables in an array and look them up by index.

- [ ] 12. [**Classes**](http://www.craftinginterpreters.com/classes.html)
  - [ ] Challenge 1: Add class methods.
  - [ ] Challenge 2: Support getter methods.
  - [ ] Challenge 3: Nothing to implement.

- [ ] 13. [**Inheritance**](http://www.craftinginterpreters.com/inheritance.html)
  - [ ] Challenge 1: Multiple inheritance. *Nothing to implement...?*
  - [ ] Challenge 2: Reverse method lookup order in class hierarchy.
  - [ ] Challenge 3: Add your own features!