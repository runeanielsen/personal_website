---
title: "JavaScript closure"
date: 2017-05-08T16:26:19+02:00
description: "In JavaScript when a function is nested inside of another function, the inner function has access to the outer function scope. The innermost function has access to all the parent scopes and therefore has closure over all of them. Because the inner function has closure over the parent functions, it is able to use the variables, even when the function has returned."
---

Closure in JavaScript is when a function is able to remember and access its lexical scope, even when that function is execution outside its [lexical scope](/posts/javascript-lexical-scope).

In JavaScript when a function is nested inside of another function, the inner function has access to the outer function scope. The innermost function has access to all the parent scopes and therefore has **closure** over all of them. Because the inner function has closure over the parent functions, it is able to use the variables, even when the function has returned. The following code shows closure in action.

```js
function foo() {
    var a = 2;
    function bar() {
        console.log(a);
    }
    return bar;
}

var baz = foo();
baz(); // 2
```

In the code above, the function "bar" can now be called by the reference stored in the variable "baz" that got returned from the function "foo" and because of the lexical scoping model, the function "bar" has access to the variable "a" that got declared inside of the function "foo" and is, therefore, able to display the value of "2" to the console. Because of closure, the function "bar" is able to use the variable "a" after the function "foo" has returned.

If closure did not exist, the function "bar" would be unable to use the variable "a" after the function returned. The reason being that the state of the function would have been garbage collected, resulting in no value being displayed to the console.

The function "foo" is not being garbage collected because the function "bar" has a **lexical scope closure** over the inner scope of "foo", which therefore keep the scope alive for "bar". The reference that the function "bar" has to the inner scope of "foo" is called closure. 

## Examples of closure

The concept of closure is mostly observed in the context of ajax request, event handlers, web workers, and timers. 

Closure, in the example below, enables the "message" variable to be displayed at a later time, when the function "timerExample" has returned. If closure did not exist the value of "message" would have been garbage collected and not being displayed. 

```js
function timerExample(message) {
    setTimeout(function timer() {
        console.log(message);
    }, 1000);
}

timerExample("Hello world!");
```

Closure can be observed clearly using loops. When the code example below is executed, you might think that the output is 1 to 10 in the console over ten seconds. Instead, the output will be "10" for every callback function. The reason is that the "setTimeout" function callbacks are running after all the iterations in the "for" loop are completed, resulting in the value of "i" being "10" for every callback. Closure plays the role of keeping the variable "i" accessible after the iterations are completed. If closure did not exist the variable "i" would have been garbage collected and no value would have been displayed to the console.

```js
for (var i = 1; i <= 10; i++) {
    setTimeout(function() {
        console.log(i);
    }, i * 1000);
}
```

To get the expected behavior, the use of an IFFE(immediately invoked function expression) is required. The IIFE creates a new scope around the "setTimeOut" function and sets the variable "j" to the value of "i" for each callback. The output being 1 to 10 being displayed over 10 seconds to the console.

```js
for (var i = 1; i <= 10; i++) {
    (function (j) {
        setTimeout(function () {
            console.log(j);
        }, i * 1000);
    })(i);
}
```

## Summary

The concept of closure in JavaScript can be defined in the following sentence: "Closure in JavaScript is when a function is able to remember and access its lexical scope, even when that function is execution outside its lexical scope".

Closure enables our code to access the inner parent scope of a function, even when the parent function has returned. The reason being that closure stops the scope of the parent function from being garbage collected, so it is accessible for later use.

Closures are most commonly observed in the context of ajax requests, event handlers, web workers, and timers.
