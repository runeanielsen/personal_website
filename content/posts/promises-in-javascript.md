---
title: "Promises in JavaScript"
date: 2017-05-22T16:26:19+02:00
description: "In JavaScript, the most common way to retrieve data is though calling an API. Calling an API is in most cases done asynchronously instead of synchronously to create the best user experience and making it possible to call multiple APIs at the same time. The standard way to call an API asynchronous is by using function callbacks. The problem with the function callback is that it is likely to introduce big nested callback chains that can be hard to debug and maintain. The new and superior way to handle asynchronous code is by using promises."
---

In JavaScript, the most common way to retrieve data is by calling an API. Calling an API is in most cases done asynchronously to create the best user experience and making it possible to call multiple APIs at the same time.

The standard way to call an API asynchronous is by using function callbacks. The problem with the function callback is that it is likely to introduce big nested callback chains that can be hard to debug and maintain. The way to prevent the nested callbacks is by using **promises**.

## Promise

The promise is a built-in feature in JavaScript. It can be used by creating a new **Promise** object.

```js
const myPromise = new Promise();
```

The initialization of the Promise object requires a function callback as a parameter. The function callback passed to the Promise constructor takes in two parameters, **resolve** and **reject.**

```js
const myPromise = new Promise(function(resolve, reject) {
    console.log('I am being executed asynchronously');
});
```

To execute the promise we make use of the method **then() **available on the **Promise** object. The function passed into the **then()** method will be executed after the promise is completed. The code example below <span style="text-decoration: underline;">won't</span> execute the function inside of the **then()** method. This is where the function parameters in the Promise constructor comes to the rescue, **resolve** and **reject**.

```js
const myPromise = new Promise(function(resolve, reject) {
    console.log('I am being executed asynchronously');
});

myPromise.then(function() {
    console.log('The promise has finished.')
});
```

To execute the code above, we will have to make use of the **resolve** parameter. The resolve parameter is a function and can, therefore, be called. The purpose of the resolve parameter is to tell that the promise completed **successfully **and execute the function callback passed into the **then()** method.

```js
let myPromise = new Promise(function(resolve, reject) {
    console.log('I am being executed asynchronously');
    resolve();
});

myPromise.then(function() {
    console.log('The promise has finished.')
});

// Outputs
// I am being executed asynchronously
// The promise is finished.
```

If the promise did **not** complete successfully we make use of the **reject** parameter. When the reject parameter is called, the function callback passed into the **catch()** method will be executed.

```js
let myPromise = new Promise(function (resolve, reject) {
    console.log('I am being executed asynchronously');

    reject();
});

myPromise.then(function () {
    console.log('The promise has finished successfully')
}).catch(function() {
    console.log('The promise has finished unsuccessfully');
});

// Outputs
// I am being executed asynchronously
// The promise has finished unsuccessfully
```

In some cases, you want to pass values back to the callback function. This can be achieved using the resolve and reject parameters and pass an argument to be used in the function callback.

```js
let myPromise = new Promise(function (resolve, reject) {
    console.log('I am being executed asynchronously');

    const test = true;
    if (test)
        resolve('The promise has finished successfully');
    else
        reject('The promise has finished unsuccessfully')

});

myPromise.then(function (value) {
    console.log(value)
}).catch(function (value) {
    console.log('Rejected');
});

// Displays
// I am being executed asynchronously
// The promise has finished successfully
```

## Why should I care about Promises?

Now that the structure and syntax of a Promise have been shown, it is time to explain why we use promises. Promises allow us to run our code asynchronously. Meaning that our code execution can continue while another piece of code is running at the same time. The code running asynchronously is the code inside of the function passed into the Promise constructor doing object initialization.

Now you might say that running asynchronously code has been possible in JavaScript for a while, but the difference with the promise is the **cleaner interface** to interact with. Promises are not much different from callbacks, and by that I mean, to use promises we have to pass a function callback into the promise doing initialization, meaning that our code still depends on callbacks. 

The difference is as I said earlier is a cleaner interface to interact with. Promises make it possible to do multiple callbacks after each other in a clean structure. The code below shows an implementation making use promises.

```js
const fetchText = (url) => {
    return new Promise((resolve, reject) => {
        // imagine calling an api service here
        resolve(url);
    });
}

fetchText('text1.txt').then(function (url) {
    console.log(url + ' downloaded');
    return fetchText('text2.txt');
}).then(function (url) {
    console.log(url + ' downloaded');
    return fetchText('text3.txt');
}).then(function (url) {
    console.log(url + ' downloaded');
    return fetchText('text4.txt');
}).then(function (url) {
    console.log(url + ' downloaded');
});

// Logs
// text1.txt downloaded
// text2.txt downloaded
// text3.txt downloaded
// text4.txt downloaded
```

The code below shows an example of the asynchronous behavior of the promise. The promise in the example uses the **setTimeOut()** function that makes the application wait for two seconds, before executing the code inside of the function callback. While the execution of the callback function in the promise is waiting for two seconds, the code keeps executing and displays the value of one to five in the "for loop". When the two seconds is over the "Request completed" message is displayed. The main thing to notice is that it is displayed later than the values one to five is displayed to the log. Meaning that our code did not run sequentially.

```js
let myPromise = new Promise(function (resolve, reject) {
    console.log('started request');
    setTimeout(function () {
        resolve('Request completed');
    }, 2000);
});

myPromise.then(function (value) {
    console.log(value)
});

for (var i = 1; i <= 5; i++) {
    console.log(i);
}

// Logs
// started request
// 1
// 2
// 3
// 4
// 5
// Request completed
```

## Promise Helper Methods

The Promise comes with helper methods. The following section will show a few of them.

Some use cases might require that we wait for multiple promises before continuing an execution. The Promise comes with a method named **all** that can help us achieve that. The following piece of code has two promises in it. Each promise is then being passed to the **all()** method as an array. The result is that before the function callback inside of the **then()** method is being executed, all promises has to be resolved. It is also possible to add the **catch()** method to the **Promise.all()** method.

```js
let promiseOne = new Promise(function (resolve, reject) {
    setTimeout(function () {
        console.log('hello from promise 1');
        resolve();
    }, 4000);5
});

let promiseTwo = new Promise(function (resolve) {
    setTimeout(function () {
        console.log('hello from promise 2');
        resolve();
    }, 1000);
});

Promise.all([promiseOne, promiseTwo]).then(function () {
    console.log('all promises finished');
});

// Logs
// hello from promise 2
// hello from promise 1
// all promises finished
```

The Promise.Race() method allows us to execute a function callback when one of a specified range of promises has been resolved or rejected. 

```js
let promiseOne = new Promise(function (resolve, reject) {
    setTimeout(function () {
        console.log('hello from promise 1');
        resolve();
    }, 4000);5
});

let promiseTwo = new Promise(function (resolve) {
    setTimeout(function () {
        console.log('hello from promise 2');
        resolve();
    }, 1000);
});

Promise.race([promiseOne, promiseTwo]).then(function () {
    console.log('all promises finished');
});

// Logs
// hello from promise 2
// all promises finished
// hello from promise 1
```
