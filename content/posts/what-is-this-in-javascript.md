---
title: "What is 'this' in JavaScript" 
date: 2017-03-23T16:26:19+02:00
description: "In a language like C# 'this' always points to the containing class, so going into JavaScript you might think that 'this' always points to the containing function, but this is not the case. Sometimes you will find 'this' actually pointing to the function, but other times you will find it pointing to the global object or to something third. In this post, I will go through the rules of how the 'this' binding is being set, so hopefully, development in JavaScript using the 'this' keyword will get easier and less confusing."
---

If you're like me coming from a strictly typed language like Java or C#, you will most likely get confused very fast going into JavaScript using the 'this' keyword.

In a language like C# 'this' always points to the containing class, so starting programming in JavaScript you might think that 'this' always points to the containing function. Sometimes you will find "this" actually pointing to the containing function, but other times you will find it pointing to the global object or even to something third. In this post, I will go through the rules of how 'this' is being set. Hopefully, after reading this blog post, development in JavaScript using the 'this' keyword will get easier and less confusing. 

## What is 'this' 

Every function, while executing, has a reference to its current execution context, called 'this'. What is meant by execution context, is where the function is being called or how the function is being called when it's called. To know what 'this' is we will have to look at the call site. Before going into that I want to eliminate some common misconceptions of what the 'this' keyword is. 

A common misconception is that 'this' always points to the containing function and is therefore not being set at runtime. Actually, it is being set at runtime based on what function that invoked the call. An example can be seen in the following code.

```js
function myFunction() {
    return this;
}
myFunction(); // Returns the window object
```

The code shows an example, where 'myFunction' is being called from the global scope and therefore is 'this' the global object. Starting out you might think that 'this' in this case is 'myFunction', but by running the code you will encounter that you get the global object back.

Another misconception is that 'this' has something to do with classes, instances or object-orienting. If you're coming from an object-oriented programming language you will have to set all your previous knowledge of what 'this' means aside, going into JavaScript. Just remember: The 'this' keyword is being set based on the execution context.

## Why do we use this?

An example can be seen in the code below, showing a constructor function named 'Customer', having two properties. The properties are being used inside of the 'displayName' function using the 'this' keyword. The usefulness of the 'this' keyword in this example is that by calling the function on an object we can use the 'this' keyword on the object and use the state that has been set on the object.

```js
function Customer(firstname, lastname) {
    this.firstname = firstname;
    this.lastname = lastname;
}

Customer.prototype.displayName = function () {
    console.log(`${this.firstname} ${this.lastname}`);
}

var customer = new Customer("John", "Foo");
customer.displayName(); // "John Foo"
```

You could in theory just pass a reference to an object to the function, and that way make use of the object state inside of the function, but the 'this' keyword creates a more elegant way to pass a reference from an object to a function, and that way eliminate a function parameter. 

```js
function displayName(customer) {
    console.log(`${customer.firstname} ${customer.lastname}`);
}

var customer = {
    firstname: "John",
    lastname: "Foo"
}

displayName(customer); // John Foo
```

## The four rules

I am happy to announce that the 'this' keyword is not being set randomly. There are four rules, that can define what 'this' keyword is at runtime. The four rules are important because they can help you when you're not sure what the 'this' keyword is going to be at runtime. To use the four rules, you first go to the call site and "ask" these four rules in order to find out what the 'this' binding is. 

1.  New
2.  Explicit
3.  Implicit
4.  Default

Before you can ask these rules, you need to know what each rule is, so in the following section, I am going to explain each rule and how they're applied.

### Default

The default binding rule is applied when calling a function without calling it on an object or by using any keyword on the function. It does not matter where the function is being called, so even if it sits inside of an IFFE the default binding rule still applies. The default binding rule says that if we are in "strict mode" then set the 'this' value to 'undefined' if not default the 'this' value to the global object. 

The code below shows an example of the default binding rule being applied. The code runs and we find the "displayName" function being called without sitting on an object or using any keyword, therefore 'this' is the global object and on the global object a variable named 'name' is declared with the value of "Toby" and therefore when calling the "displayName" function the 'this.name' value is "Toby". 

```js
function displayName() {
    console.log(this.name)
}

var name = "Toby";

displayName(); // Toby - Default Binding
```

### Implicit

The implicit binding rule says that if there is an object at the call site, that object becomes the 'this' binding. The code below shows an example of two objects being at the call site and therefore displaying the value "Dennis" and "Alexander" because they were applied to the objects on their initialization.

```js
function displayName() {
    console.log(this.name)
}

var userOne = { name: "Dennis", displayName: displayName };
var userTwo = { name: "Alexander", displayName: displayName };

userOne.displayName(); // Dennis - Implicit
userTwo.displayName(); // Alexander - Implicit
```

### Explicit

The explicit binding rule says that if you use '.call' or '.apply' at the call site and pass the required object reference into the function the 'this' binding is set to the object that is passed into the function. This means that we are explicitly stating what 'this' binding should be.

```js
function displayName() {
    console.log(`${this.firstname} ${this.lastname}`);
}

var customerJohn = {
    firstname: "John",
    lastname: "Foo"
}

var customerDan = {
    firstname: "Dan",
    lastname: "Foo"
}

displayName.apply(customerJohn); // John Foo - Explicit
displayName.call(customerDan); // Dan Foo - Explicit
```
    
### New

By using the 'new' keyword a call to a function becomes a constructor call. There are four things that happen when the 'new' keyword is set in front of a function call. 

1) A new object is created.
2) The object gets linked to another object.
3) The object that got created gets bound to the 'this' keyword in that function call.
4) If the called function does not return anything there will implicitly be inserted a return 'this'. So the newly created object will get returned. 

So the code below shows the fourth way of 'this' binding can be set by doing a constructor call. 

```js
function Customer(name) {
    this.name = name;
    console.log(this.name);
}

var customer = new Customer("Kenneth"); // Kenneth - New binding
```

## Summary

To find out what the 'this' keyword is, you can make use of the four rules.

1) Was the function called with the 'new'? If yes then the value of this is the new object created.
2) Was the function called with 'call' or 'apply'? If yes then the 'this' is the object passed in as a parameter in the implicit call.
3) Was the function called by a containing/owning object? If yes then the binding of 'this' is the containing object. 
4) Was the function called not using any of the above? If yes then the binding of 'this' is the global object if not in "strict mode" else it is undefined. 

I hope this introduction to 'this' helped explain how the binding of 'this' is being set in JavaScript.
