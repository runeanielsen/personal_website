---
title: "Hoisting in JavaScript"
date: 2017-03-23T16:26:19+02:00
description: "In JavaScript, a variable can be declared after it has been used. In other words, a variable can be used before it has been declared, this is called hoisting. The term hoisting cannot be found in the official JavaScript documents, but the term was invented as a general way of thinking about what happens in the compilation phase when variables and function declarations are moved to the top of their containing scope. To be exact the variables are not being moved to the top of the scope, but they're being stored in memory doing the compile phase, so they can be used in the execution phase."
---

In JavaScript, a variable can be declared after it has been used. In other words, a variable can be used before it has been declared, this is called **hoisting**. The term hoisting cannot be found in the official JavaScript documents, but the term was invented as a general way of thinking about what happens in the compilation phase when variables and function declarations are "moved" to the top of their containing scope. To be exact the variables are not being moved to the top of the scope, but they're being stored in memory doing the compile phase, so they can be used in the execution phase.

The following code shows an example where we declare the variable 'a'. Because of hoisting the variable 'a' will get hoisted to the top of the function scope and be initialized to the value assignment of 10\. In a language who does not hoist, this would have thrown an error.

```js
a = 10;
displayValue();
function displayValue() {
    console.log(a); // Outputs: 10
}
var a;
```

So a way to visualize this is by "moving" the variables and function declarations to the top of the code. First, the functions get moved to the top, then the variables.

```js
function displayValue() {
    console.log(a);
}
var a;
a = 10;
displayValue();
```

To prove that function declarations are moved before variable declarations, we will use the following code example. Doing the compilation phase the first function 'foo' is moved to the top. After that, the other function 'foo' overwrites the first function that logged "bar" so it now returns "foo". Last the variable 'foo' gets hoisted, but because 'foo' already was declared as a function the declaration gets ignored.

```js
foo(); // Outputs: "foo"

var foo = 2;

function foo() {
    console.log("bar");
}

function foo() {
    console.log("foo");
}
```

One thing to mention is that a function declaration is hoisted over a variable declaration but not over the variable assignment. To prove this statement take a look, at the code example.

```js
var double = 22;

function double(num) {
return (num*4);
}

console.log(typeof double); // Output: number
```

## Benefits of hoisting

Hoisting brings the benefit that we can call a function before it has been declared as can be seen in the following code. If hoisting did not exist we would have to declare all our functions before we could use them.

```js
sayHello(); // Outputs: Hello

function sayHello() {
    console.log('Hello!');
}
```

A common error for many developers is that they think function expressions will be set at the compile phase, but they're actually set at the execution phase because of the function not being declared, but it is being assigned to a variable. Therefore this code will throw an error, at the execution phase, because the 'sayHello' variable has not been set to a function expression.

```js
sayHello(); // Throws: sayHello is not a function

var sayHello = function () {
    console.log('Hello!');
}
```

## ES6 and hoisting

ES6 also known as ECMAScript 2015 bring two new ways to assign variables, **let** and **const**. They're interesting because they have different behavior than the **var** variable declaration in the case of hoisting.

### Let

The **var** keyword is function scoped meaning that the variable is bound to the function in which it is declared. On the other hand, **let** is block scoped meaning that it is bound to the block instead of the function.

We learned earlier that a variable can be used before declared using the **var** keyword. Using **let** instead throws a reference error because variables declared using the **let** keyword are not being hoisted to the top. This behavior can be seen in the code below.

```js
console.log(bar); // Output: ReferenceError: bar is not defined
let bar = 'foo';
```

### Const

The **const** keyword was introduced into ES6 to allow immutable variables. Immutable variables are variables who cannot be modified once assigned. Same as the **let** keyword **const** is not hoisted to the top of the block. The same exception as the **let** example is thrown as can be seen in the code below.

```js
console.log(bar); // ReferenceError: bar is not defined
const bar = 'foo';
```

The important part about this section is that ES6 gives us two new ways to declare variables and neither of them are hoisted. Variables declared with **let** and **const** remain uninitialised at the compilation phase while variables declared with **var** are initialised with a value of undefined and can, therefore, be used before it has been declared.

## Summary

JavaScript uses the concept of hoisting on variable and function declarations. Hoisting makes it possible to use a variable or a function before it has been declared, and is beneficial because it enables us to call a function before it has been declared. The problem with hoisting is that it might course confusion for people coming from a language that does not hoist.
