---
title: "JavaScript understanding scope"
date: 2017-04-14T16:26:19+02:00
description: "To efficiently program in javascript you will have to understand the principle of scope. The javascript scope is the set of variables you have access to, this goes for both objects and functions since in javascript functions and objects are also variables. To better understand scope we will have to look into how javascript is being executed. By taking a look at the compiler, engine and the scope." 
---

# JavaScript understanding scope

To efficiently program in javascript you will have to understand the principle of scope. The javascript scope is the set of variables you have access to, this goes for both objects and functions since in javascript functions and objects are also variables. To better understand scope we will have to look into how javascript is being executed. 

In javascript, there are three main actors in the execution, engine, compiler and scope. 

*   The engine is responsible for the compilation and execution of our program.
*   The compiler handles all the parsing and code generation.
*   Scope collects and maintains a look-up list of all declared variables, and enforces the rules of how they can be accessed. 

If we take a look at the following code, we would think of it as a single statement. 

```js
var a = 10;
```

The engine does not see it as a single statement, but as two statements which it will find using lexing, a technique to split statements up into tokens. The first statement is "var a" and will be handled by the compiler doing the compilation phase and the other statement "a = 10" will be handled by the engine doing the execution phase.

In the compilation phase, the compiler sees the variable declaration of "a" and then asks the current scope collection if the variable "a" already has been declared in the current scope. If it has already been declared the compiler ignores the declaration and moves on. If it has not been declared the compiler "asks" the scope to declare a variable named "a" in the current scope collection. 

When the compilation phase is completed the engine takes over and sees the assignment declaration of "a = 10". It then asks the current scope if it has a variable declaration named "a" in the current scope collection if it has, it assigns the value if not it "bubbles" up and looks in the next outer scope until it either finds it or it does not. If it does not find it, it will either throw an error or create the variable for you depending on if the program is in strict mode or not. 

## Nested Scope

In javascript scopes are nested, just like functions can be nested inside of other functions. As described earlier if a variable cannot be found in the current scope then the engine looks in the outer scope to see if that scope has the variable declared, it keeps doing this until it reaches the global scope. If the variable has not been declared and the global scope has been reached two things can happen. If in strict mode there will be thrown an error if not in strict mode a variable of the specific name will be created and assigned to the value.

The following code shows an example of a nested scope. The variable "b" is being used inside of the function named "foo". The variable "b" has not been declared inside of "foo" so engine ask the scope outside of the function if it has the variable "b" defined. In this case, the variable has been declared and the calculation can be completed. 

```js
function foo(a) {
    console.log(a + b);
}

var b = 2;
foo(2); // outputs 4
```

This code example shows a variable declaration being bound to the current scope. The function "foo" uses the local variable declaration of "b" instead of the outer declaration of "b" because it first "asks" the current scope if it has a variable declaration named "b" it has and therefore uses that declaration instead of trying to find it in the next outer scope. 

```js
function foo(a) {
    var b = 20;
    console.log(a + b);
}

var b = 2;
foo(2); // outputs 22
console.log(b); // outputs 2
```

## Summary

The scope is the rules that determine what variables you have access to in your javascript code. It is important to remember that a statement is being split into multiple tokens using lexing that the compiler and engine will handle differently. 

A nested scope is a scope that is inside of another scope, just like functions can be inside of other functions. When the engine asks the scope to look for a variable it will always start from the current scope to search for the variable and if it does not find it, it will ask the outer scope if that has the variable declared it will keep doing this until it eventually finds the variable or does not find it, what happens next depends on if the program is in strict mode or not.
