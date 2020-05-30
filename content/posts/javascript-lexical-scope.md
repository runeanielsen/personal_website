---
title: "JavaScript lexical scope"
date: 2017-05-01T16:26:19+02:00
description: "In this blog post, I will explain how the lexical scoping model is defined and how it is being used in JavaScript. I will go over how the lexical scope differs from the dynamic scoping model by using the example of the how the execution of a JavaScript program would look like if it was using the dynamic scoping model and after that showing how it is done in JavaScript using the lexical scoping model."
---

In this blog post, I will explain how the lexical scoping model is defined and how it is being used in JavaScript. I will go over how the lexical scope differs from the dynamic scoping model by using the example of the how the execution of a JavaScript program would look like if it was using the dynamic scoping model and after that showing how it is done in JavaScript using the lexical scoping model.

## Lexical Scope

The lexical scope also called static scope defines how variables are resolved in nested functions. In JavaScript, we nest functions and therefore also nest scopes. The inner scope, therefore, has access to the parent function scope even if the parent function has returned.

The lexical scope is set at the time off lexing, meaning that the lexical scope is based on where the variables and blocks of scopes are written in code, and by that enabling performance optimization. 

Let's take a look at the following code.

```js
function foo() {
    var a = 20;
    console.log(b); // displays 10
    console.log(a); // displays 20

    baz();
    function baz() {
        console.log(a); // displays 20 
    }
}

function bar () {
    console.log(b); // displays 10
    console.log(a); // undefined
}

var b = 10;
foo();
bar();
```

Because we use the lexical scoping model the variables are only available in the current function and in the parent functions.

The example shows how the variables are available in the current scope and the parent scope. If we look at the function "foo" it has access to the variable "a" because it is declared inside of the current scope and it also has access to the variable "b" because it is defined in the parent function of "foo".

In contrast, the function "bar" does only have access to the variable "b" because it has been declared in the parent function, but not the variable "a" because it is inside of the scope of another function. 

If we compare this to the dynamic scoping model. The program would display the variable "a" inside of the function "bar" even though it has not been declared in the same scope or parent scope of the function. The reason for this is that the dynamic scoping model does not make the variables only accessible to the current scope or parent scope, but to all the scopes in the program.

The code below shows how the same program as before would execute if it was using the dynamic scoping model.

```js
function foo() {
    var a = 20;
    console.log(b); // 10
    console.log(a); // 20

    baz();
    function baz() {
        console.log(a); // 20 
    }
}

function bar () {
    console.log(b); // 10
    console.log(a); // 20
}

var b = 10;
foo();
bar();
```

## Lookups

When the engine reaches a variable it does a lookup. A lookup is when the engine tries to retrieve a variable from the scope. To retrieve the variable it first looks for the variable inside of its own scope. If it finds the variable inside of the functions own scope it retrieves it, if it does not find it, it goes to the next outer function to see if it can find it there. If it finds it in either of the parent scopes it retrieves it.

If it does not find the variable in either of the parent functions scope it either throws an error if the program is in "strict mode" or the global scope creates a new variable and returns it. 

```js
function foo() {
    var b = 100;
    console.log(a); // 20
    console.log(b); // 100

    baz();
    function baz() {
        var a = 200;
        console.log(a); // 200
        console.log(b); // 100
    }
}

var a = 10;
var b = 20;
foo();
console.log(a); // 10
console.log(b); // 20
```

The lookup phase is highly optimized because the JavaScript engine predetermines where all the variables and function declarations are, doing the compilation phase. This is possible because the lookups can be determined by compile time.

One thing to note is that if you make use of the "eval" function in JavaScript your code might run slower because "eval" can be used to cheat the lexical scoping model and therefore the compiler has to reduce performance because variables not being able to be stored for quick lookup. 

## Summary

The lexical scope is the scoping model where the scope is defined by the position of the declaration of the functions. The lexical scope stands in contrast to the dynamic scope where the position of declarations has no meaning for the scope lookup.

In the compile phase, the JavaScript engine performance optimizes the lookups, by looking at the declaration placements in the code. 

Doing runtime the engine asks the scope to find the variables in the scope by first asking the inner-most scope and going out till it either finds it or reaches the global scope.
