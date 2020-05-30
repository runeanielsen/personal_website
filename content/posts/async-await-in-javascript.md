---
title: "Async await in JavaScript"
date: 2017-06-12T16:26:19+02:00
description: "Async/await is a way to handle asynchronous code in JavaScript. Before async/await the only options were to use callbacks and promises resulting in highly nested structures. The benefit of using async/await is that it creates a cleaner way to structure asynchronous code without having to rely on nested callbacks or confusing promise chains."
---

Async/await is a way to handle asynchronous code in JavaScript. Before async/await the only options were to use callbacks and promises resulting in highly nested structures. The benefit of using async/await is that it creates a cleaner way to structure asynchronous code without having to rely on nested callbacks or confusing promise chains.

To start using async/await the first step is to create a new function using the **async** prefix on the function declaration. The async keyword is used to specify that the function will contain asynchronous code that should be awaited.

```js
async function myAsynchronousFunction() { }
```

Next step is to use the **await** keyword. _Note that the await keyword only can be used inside of functions marked with the async keyword._ The await keyword is used when the code should wait for an asynchronous operation to finish before continuing execution.

In the code below we await the function named "myFunctionToBeAwaited". The expected behavior of the code is to first display "Hello World One!" and after 1.5-second display "Hello World Two!" to the console. The code below does not do the proposed behavior. The reason that the code below does not behave like we want it to, is that await, awaits a [promise](/post/promises-in-javascript "Blog Post on Promises.") to be resolved or rejected. So to get the correct behavior we will have to return a promise from the function "myFunctionToBeAwaited".

```js
// myFunctionToBeAwaited is not awaited
async function myAsynchronousFunction() {
    await myFunctionToBeAwaited();
    console.log('Hello World Two!');
}

function myFunctionToBeAwaited() {
    setTimeout(() => {
        console.log('Hello World One!');
    }, 1500);
}

myAsynchronousFunction();

// Outputs
// Hello World Two!
// Hello World One!
```

By returning a Promise inside of "myFunctionToBeAwaited", the function is now correctly awaited. To tell that the asynchronous function is completed, **resolve** or **reject** needs to be called inside of the callback function passed to the promise. If resolve or reject is never called, the function never returns, and the program execution never continues.

```js
// myFunctionToBeAwaited is awaited
async function myAsynchronousFunction() {
    await myFunctionToBeAwaited();
    console.log('Hello World Two!');
}

function myFunctionToBeAwaited() {
    return new Promise(resolve => {
        setTimeout(() => {
            console.log('Hello World One!');
            resolve();
        }, 1500);
    });
}

myAsynchronousFunction();

// Outputs
// Hello World One!
// Hello World Two!
```

## Await multiple promises

Awaiting multiple promises at the same time is not possible by simply using the await keyword. To accomplish awaiting multiple promises we use the **Promise.all()** method on the global **Promise** object. The Promise.all() method first resolves when all promises passed as an array to the Promise.all() has been resolved.

The code example shows how awaiting multiple promises can be achieved by using the Promise.all() method.

```js
async function myAsynchronousFunction() {
    let [first, second] = await Promise.all([awaitedOne(), awaitedTwo()]);

    console.log(first);
    console.log(second);

    console.log('Hello World Three!');
}

function awaitedOne() {
    return new Promise(resolve => {
        setTimeout(() => {
            console.log('Hello World One!');
            resolve('First');
        }, 1500);
    });
}

function awaitedTwo() {
    return new Promise(resolve => {
        setTimeout(() => {
            console.log('Hello World Two!');
            resolve('Second');
        }, 500);
    });
}

myAsynchronousFunction();

// Outputs
// Hello World Two!
// Hello World One!
// First
// Second
// Hello World Three!
```

## Error Handling using Async/Await

Using async/await creates a simpler interface for dealing with error handling. The idea is that async/await lets us use **try-catch blocks** around the awaited promises, resulting in cleaner error handling.

The code below displays the old way of using **then** and **catch** to handle promises. In the example, the function "myFunction" only contains two nested promises, but it is already hard to handle the exceptions and reason about the flow of the program. _Imagine what it would look like having four or more promises being nested..._

```js
function myFunction(param) {
    asyncFunction(param).then((response) => {
        console.log(response);
        asyncFunction('bad value').then((response) => {
            console.log(response);
        }).catch((error) => {
            console.log(error);
        });
    }).catch((error) => {
        console.log(error);
    });
}

function asyncFunction(value) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (value === 'bad value')
                reject('Something went wrong!');

            resolve('Something went great!');
        }, 1500);
    });
}

myFunction('bad value');
myFunction('good value');

// Logs
// Something went wrong!
// Something went great!
// Something went wrong!
```

In the code below async/await with a try-catch block around is used instead of promise chains with catch callbacks to handle errors. The result of using async/await is a function that contains less code and is easier to follow the program flow of. Instead of the program becoming a lot more complicated by adding another promise like it would using only promises. A program using async/await does not get more complicated and keeps a non-nested structure no matter how many promises there is to be awaited.

```js
async function myFunction(param) {
    try {
        const responseOne = await asyncFunction(param);
        console.log(responseOne);

        const responseTwo = await asyncFunction('bad value');
        console.log(responseTwo);
    } catch (error) {
        console.log(error);
    }
}

function asyncFunction(value) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (value === 'bad value')
                reject('Something went wrong!');

            resolve('Something went great!');
        }, 1500);
    });
}

myFunction('bad value');
myFunction('good value');

// Logs
// Something went wrong!
// Something went great!
// Something went wrong!
```

## Summary

To harness the power of async/await, we should declare our function with the **async** keyword. The async declaration on the function enables us to use **await** inside of the async function.

The await keyword tells us that we should await a function before continuing the function execution. To correctly await a function, the function that is to be awaited should return a promise. The promise takes a callback that either **resolves** or **rejects**. When the promise resolves or rejects the function execution of the function that awaits continues.

Awaiting multiple promises is possible by using the Promise.all() method. Remember that the sequence of passed in promises does not mean that they return in the same order.

The async/await keywords helps us with creating cleaner error handling dealing with promises because they allow us to use try-catch blocks around the awaited promises instead of using the catch method that takes a callback for each promise.
