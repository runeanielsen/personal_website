---
title: "Array methods in JavaScript"
date: 2017-05-15T16:26:19+02:00
description: "Working with collections are a daily task, as a programmer. JavaScript uses the Array as the main type of collection. In this blog post, I will go over the methods on the array that I find most useful. Hopefully, the introduction to the methods will be increasing your productivity, working with collections and increasing the readability and maintainability of your code."
---

Working with collections are a daily task, as a programmer. JavaScript uses the **Array**** type **as the main type of collection. In this blog post, I will go over the methods on the array that I find most useful. Hopefully, the introduction to the methods will increase your productivity, working with collections and increasing the readability and maintainability of your JavaScript code. 

## Filter

The **filter()** method creates a new array containing only the values, that pass the test of the function, passed as an argument to the filter method. The way that the filter evaluates, that the item in the array passed the test provided, is by using the boolean value returned doing each iteration. If the returned value is **true** the element will be pushed to the returned array, if it is **false** the value will not.

The filter method callback function is invoked by the following three arguments.

1.  the value of the element
2.  the index of the element
3.  the array object being traversed

The example shows a set of values being filtered. The provided condition evaluates if the value is four or greater. If the value is not four or greater, the item does not get pushed to the returned array.

```js
const values = [1, 5, 3, 2, 10, 11, 4];

var filteredArray = values.filter(value => {
    return value >= 4;
});

console.log(filteredArray); // [ 5, 10, 11, 4 ]
```

The following example shows how the filter method can be used to remove all objects from an array that don't have a specific property, in this case, the last name.

```js
const customers = [
    { name: 'Dennis', lastname: 'Knudsen' },
    { name: 'Sara', lastname: 'Olsen' },
    { name: 'Mikkel' }
];

const customerWithLastName = customers.filter(customer => {
    return customer.hasOwnProperty('lastname');
});

console.log(customerWithLastName);

// Displays
// [
//     { name: 'Dennis', lastname: 'Knudsen' },
//     { name: 'Sara', lastname: 'Olsen' }
// ]
```

The code below shows how the filter method can be used to query an array of objects based on the value of a property. 

```js
const customers = [
    { name: 'Dennis', lastname: 'Knudsen' },
    { name: 'Sara', lastname: 'Olsen' },
    { name: 'Mikkel', lastname: 'Johnson' }
];

function filterItems(collection, prop, query) {
    return collection.filter(function (el) {
        return el[prop].toLowerCase().indexOf(query.toLowerCase()) > -1;
    });
}

console.log(filterItems(customers, 'lastname', 'sen'));

// Displays the following to the console
// [
//     { name: 'Dennis', lastname: 'Knudsen' },
//     { name: 'Sara', lastname: 'Olsen' }
// ]
```

## Reduce

The **reduce()** method, reduces the array to a single value. Using the reduce method, the array it is used on is iterated over each value. The reduce method takes in a function callback. 

The reduce method function callback is invoked with the following four parameters:

1.  the accumulator
2.  the currentValue of the element
3.  the currentIndex of the element in the array
4.  the array that the reduce method is being invoked on

The way that the function callback should be structured, is by using the accumulator to store the value which should be returned after all iterations over the array are completed. The accumulator value is set to the value returned doing each iteration. 

The code below shows the reduce method being used to sum a collection of numbers.

```js
const values = [1, 14, 2, 3, 11, 15, 12];

const sum = values.reduce((acc, val) => {
    return acc += val;
});

console.log(sum); // 58
```

The reduce method can also be used to flatten a collection of arrays. 

```js
const nestedCollection = [0, [1, [2, [3, [4, [5]]]]]];

const flatten = arr => arr.reduce((acc, val) => acc.concat(
    Array.isArray(val) ? flatten(val) : val), []
);

const flattenCollection = flatten(nestedCollection);

console.log(flattenCollection); // [ 0, 1, 2, 3, 4, 5 ]
```

## Map

The **map()** method creates a new array with the results of calling a function for every element in the array. The map method takes a function callback as the parameter.

The map method function callback is invoked with the following three parameters:

1.  the current value of the element
2.  the index of the element
3.  the array that invoked the map method

The example shows how an array of numbers. Each number is being taken the natural logarithm of and returned as a new array. If the callback, that is being passed into the map method only takes one parameter, it is possible to just send the reference to the function into the map method, as being shown below.

```js
const values = [1, 14, 2, 3, 11, 15, 12];

const newValue = values.map(Math.log);

console.log(newValue);

// Logs the following values
// [
//     0,
//     2.6390573296152584,
//     0.6931471805599453,
//     1.0986122886681096,
//     2.3978952727983707,
//     2.70805020110221,
//     2.4849066497880004
// ]
```

Another example of a use case of the map method can be seen below. In the example, a function is passed to the map method that checks each value in the array and returns a new object containing a property with the current number and a property that states if the current number is even or not.

```js
const values = [1, 14, 2, 3, 11, 15, 12];

const isEvenNumber = values.map(function (number) {
    return { number: number, isEven: number % 2 === 0 };
});

console.log(isEvenNumber);

// Displays
// [
//     { number: 1, isEven: false },
//     { number: 14, isEven: true },
//     { number: 2, isEven: true },
//     { number: 3, isEven: false },
//     { number: 11, isEven: false },
//     { number: 15, isEven: false },
//     { number: 12, isEven: true }
// ]
```

## Sort

The **sort()** method is used to sort the array that the method is called on. It does not return a new array but **modifies** the array that has called the method. The sort method takes an optional function callback. If no callback function is passed to the method, it sorts the array by converting each element to a string and sort the element by the Unicode value of the characters, in the string.

If a function callback is supplied, the array elements are sorted by the return value of the function callback. The way that the compare function sorts the elements is by using the return value. The return value can be calculated by using the two numbers that are passed into the compare function. 

*   If the compare(a, b) function return value is less than 0 then a is sorted to a lower index than b.
*   If compare(a, b) function returns 0, the index of a and b is not changed.
*   If compare(a, b) return value is greater than 0, b is moved to a lower index than a. 

The example below shows how the sort method can be used to sort an array of numbers in **ascending** order. If the numbers need to be sorted by **descending**, then it can be achieved by returning **b - a**.

```js

const numbers = [1, 5, 20, 2, 30, 22, 15, 10];

numbers.sort(function(a, b) {
    return a - b;
});

console.log(numbers); // [ 1, 2, 5, 10, 15, 20, 22, 30 ]
```

## Find

The **find()** method return the value of the first element in the array that satisfies the provided test function. The way that the test function should work, is that if the value returned is **false**, the iteration of the array **continues**. If the return value is **true**, the iteration of the array is **stopped** and the current element is returned.

The find method function callback is invoked with the following four parameters

1.  The current element in the array
2.  The index of the current element
3.  The array that the find method is called upon
4.  Object to use as this when executing the callback function.

The example shows how the find method can be used to find a customer based on the city property.

```js
const customers = [
    { name: 'Michael', city: 'Bristol' },
    { name: 'Sine', city: 'Aarhus' },
    { name: 'Jonas', city: 'Copenhagen' },
    { name: 'Claudia', city: 'New York'},
]

const specificCustomer = customers.find(function(customer) {
    return customer.city === 'Copenhagen';
});

console.log(specificCustomer); // { name: 'Jonas', city: 'Copenhagen' }
```

In the following piece of code, the find method is used to query a collection based on a property and a query value.

```js
const customers = [
    { name: 'Michael', city: 'Bristol' },
    { name: 'Sine', city: 'Aarhus' },
    { name: 'Jonas', city: 'Copenhagen' },
    { name: 'Claudia', city: 'New York'},
]

function queryCollection(collection, property, query) {
    return collection.find(function(element) {
        return element[property] === query;
    });
}

console.log(queryCollection(customers, 'name', 'Sine')); // { name: 'Sine', city: 'Aarhus' }
```
