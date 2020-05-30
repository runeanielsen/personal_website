---
title: "Generators in JavaScript"
date: 2017-05-29T16:26:19+02:00
description: "ES6 came with a new type of function called a generator. A generator in JavaScript is a function that can be entered and exited that saves its current state across multiple re-enterings of the function. In this blog post, I will go over how to create a generator and how to use it. In the end of the post, I will show a use-case where a generator function can be applied."
---

A generator in JavaScript is a function that can be entered and exited that saves its current state across multiple re-enterings of the function. In this blog post, I will go over how to create a generator and how to use it. In the end of the post, I will show a use-case where a generator function can be applied.

Creating a generator is simple. Create a function and append the '*' symbol next to the function declaration.

```js
function* myGenerator() {}
```

Next, we need to use our generator. In the example below, we create a variable named "index". The variable gets incremented in a while loop until it's value is 2\. As the code is right now, it does not benefit from the features of the generator. To make use of the generator, we need to use the keyword "yield".

```js
function* myGenerator() {
    let index = 0;
    while (index < 3)
        index++;
}
```

The **yield** keyword is used as a return statement inside of the generator. Meaning that once yield is called we exit the function. In the example below, the generator function would exit with the value of the variable "index" being zero. Even though the generator function yielded the value zero, the value is now one inside of the generator function.

```js
function* myGenerator() {
    let index = 0;
    while (index < 3)
        yield index++;
}
```

To use the generator we need to call the generator function. Calling the generator function for the first time returns an **iterator object**(it is important to call the generator function the first time, or you won't be able to use the methods on it). The iterator object has three methods, **next**, **return** and **throw**. Let's take a look at the most important one, **next**.

```js
function* myGenerator() {
    let index = 0;
    while (index < 3)
        yield index++;
}

const myIterator = myGenerator();
myIterator.next();
myIterator.return();
myIterator.throw();
```

## Next

Calling the next method on the iterator object returns an object containing two properties, **value** and **done**. The value property contains the yielded value returned from the generator function.

The done property represents the status of the generator. If no yield keyword was hit in the generator function after calling the next method on the iterator object the value of done is **true** else it is **false**.

```js
function* myGenerator() {
let index = 0;
while (index < 3)
    yield index++;
}

// get the iterator object
const a = myGenerator();

// the iterator object lets us call the next method
console.log(a.next()); // { value: 0, done: false }
console.log(a.next()); // { value: 1, done: false }
console.log(a.next()); // { value: 2, done: false }
console.log(a.next()); // { value: undefined, done: true }
```

Same code with the removed yield keyword. Because no yield was ever hit, the done property is set to true on every next method call.

```js
function* myGenerator() {
    let index = 0;
    while (index < 3)
        index++;
}

// get the iterator object
const a = myGenerator();

// the iterator object lets us call the next method
console.log(a.next()); // { value: undefined, done: true }
console.log(a.next()); // { value: undefined, done: true }
console.log(a.next()); // { value: undefined, done: true }
console.log(a.next()); // { value: undefined, done: true }
```

The done property is very useful for iteration purposes. The code example below uses the done property to run until the value of done is set to true.

```js
function* myGenerator() {
    let index = 0;
    while (index < 10)
        yield index++;
}

// get the iterator object
const a = myGenerator();

let b;
do {
    b = a.next();
    console.log(b.value);
} while (!b.done)

// Logs 0 to 9 and undefined on last next call

```

## Return

If you ever need to stop the generator early and clear the state, it can be done by using the return() method on the iterator object. The return method is useful if the generator function calls an API, and the API returned the wrong data. In this case, you want to stop the iteration and clear the state, to try again.

```js
function* myGenerator() {
    let index = 0;
    while (index < 10)
        yield index++;
}

// get the iterator object
const a = myGenerator();

const data = a.return(10);
console.log(data); // { value: 10, done: true }
```

## Throw

The throw() method is an available method on the iterator object. The method enables us to throw an error if something goes wrong.

In the example below, the throw method is being used to throw an error if the yielded value is 10\. What happens then is that the generator has a try catch block around the yield keyword and therefore catches the error. The thing to notice is that the throw method enters the generator function and throws the error at the position of the yield keyword.

```js
function* gen() {
    while (true) {
        try {
            yield 10;
        } catch (e) {
            console.log(e);
        }
    }
}

var g = gen();
const value = g.next().value;

if (value === 10)
    g.throw(new Error('Something went wrong'));

/* 
Logs:
Error: Something went wrong
    at Object.<anonymous> (/index.js:14:9)
    at Module._compile (module.js:571:32)
    at Object.Module._extensions..js (module.js:580:10)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)
    at Function.Module._load (module.js:439:3)
    at Timeout.Module.runMain [as _onTimeout] (module.js:605:10)
    at ontimeout (timers.js:386:14)
    at tryOnTimeout (timers.js:250:5)
    at Timer.listOnTimeout (timers.js:214:5) 
*/
```

## Making async code sync using generators

Generators can be beneficial when working with async code that is needed to be synchronous. The reason can be that a specific set of API requests should finish in a certain order because the data from the previous request is required for the next request. This can be achieved in a clean way using generators.

The code below is an example of how asynchronous requests can be made synchronous using a generator function. The important part of the code is how the generator implementation uses the previous response to do the next request. This is done by using the callback function inside of the "ajaxRequest" function calling the **next** method on the iterator object, this is happening until the generator function does not yield return. 

```js
function request(url) {
    // Imagine this piece of code calls an http request implementation
    ajaxRequest(url, function (response) {
        iterator.next(response);
    });
}

function* requestGenerator() {
    let firstResult = yield request("http://my-website.com");
    let data = JSON.parse(firstResult);

    let secondResult = yield request("http://my-website?id=" + data.value.id);
    let response = JSON.parse(secondResult);
    console.log("The value you asked for: " + response.value);
}

// Get the iterator object
const iterator = requestGenerator();

// Start the iteration
iterator.next();
```
