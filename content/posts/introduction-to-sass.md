---
title: "Introduction to Sass"
date: 2017-06-26T16:26:19+02:00
description: "Sass is a superset of CSS. The word superset implies that Sass includes all the features of CSS, but also introduces a whole new range of features and concepts that developers can benefit from. In this blog post, I will go over each of the features that Sass brings and explain the benefit of using them."
---

Sass is a superset of CSS. The word superset implies that Sass includes all the features of CSS, but also introduces a whole new range of features and concepts that developers can benefit from. In this blog post, I will go over some of the features that Sass brings and explain the benefit of using them.

## Preprocessing

Sass is a transpiled language. A transpiled language is a language that is taken through a transpiler also called a source-to-source compiler. The transpiler takes source code from one language, in our case the language Sass and outputs CSS code.

The reason that we have to transpile Sass to CSS is that browsers do not understand Sass. Consequently, the only way for the browser to understand our Sass code is to convert it to the equivalent CSS code. By this, we can conclude that everything we can do in Sass can be achieved in CSS. Because if it was not achievable in CSS we would not be able to transpile our Sass to CSS.

## Sass vs. Scss

The Sass language involves two languages Sass and Scss. In this section, I will briefly go over both of the languages and explain the differences.

**Sass**

Sass stands for "Syntactically Awesome Style-Sheets" and is the original language of Sass. Sass benefits from shorter syntax but is considerably more different in syntax from CSS compared to Scss.

Sass is not used as much as Scss. A reason that fewer people use Sass than Scss is that Scss is syntactically closer to CSS and accordingly has an easier learning curve.

Sass removes a lot of syntax from CSS. It removes the semicolon for line ending and brackets for selectors. It is therefore very important in Sass that you indent correctly and create a new line for every selector value. The removal of syntax in Sass means that it is considered a faster language to develop in, but the increase in speed also makes it more prone to syntactical mistakes.

Below is an example of a class selector targeting a class named "block". The central point to recognize is that Sass does not use any semicolons and brackets, but relies on indentation and line breaks.

```css
.block 
    display: block
    background-color: gray
    padding: 20px
```

**Scss**

Scss stands for "Sassy CSS" and is the newer syntax of Sass. Scss looks very much like CSS and uses the same syntax.

The code below is an example of how a class selector targeting a class named "block" can be defined in Scss. The nice thing about Scss is that in its most basic form it is identical to CSS. Meaning that developers can just rename their .css file to .scss and get started using the features of Scss. I will be using the Scss syntax for the rest of the post.

```css
.block {
    display: block;
    background-color: gray;
    padding: 20px;
}
```

## Variables

The concept of a variable is fundamental in programming. A variable brings the benefit of being able to use the same value in multiple places by using a reference to a variable instead of using the variable itself. CSS does not have the concept of a variable. If we ever need to change all the text colors on a website, we would have to find every place where we use the specific color and change it manually. With a variable, we could define it once, and with one value change, all the text colors would've been changed.

Fortunately, Sass introduces the concept of a variable. Variables in Sass can hold all assignable types from CSS and Sass. To define a variable we use the '$' prefix with root being the name of the variable.

```css
$font-stack: Arial, "Helvetica Neue", Helvetica, sans-serif;
$primary-text-color: gray;
$font-size: 2em;
```

Using the variable is as simple as defining it. Just use the variable in the property assignment instead of using a hard-coded value.

```css
/*The Sass code */
$font-stack: Arial, "Helvetica Neue", Helvetica, sans-serif;
$primary-text-color: gray;
$font-size: 2em;

body {
    font-family: $font-stack;
    color: $primary-text-color;
    font-size: $font-size; 
}

p {
    font-size: $font-size;
}

/* The CSS outputted after transpilation */
body {
    font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
    color: gray;
    font-size: 2em;
}

p {
    font-size: 2em;
}
```

 As can be seen in the transpiled code, all the variables we defined is now replaced with the value of the variables that we defined in our Sass code. 

## Nesting

When working in CSS you often want to select elements that represent a nested structure in HTML. Because of the current syntax of CSS, it can be tedious to write the same selector multiple times, to target a specific nested element in HTML. An example could be the following.

```css
li {
    font-size: 2em;
}

li a {
    color: blue;
}
```

Sass allows us to use a nesting structure that more clearly represents the structure of the HTML element we want to target. Using nesting in Sass the code above can be achieved as shown in the code example below.

```css

/* The Sass code */
li {
    font-size: 2em;

    a {
    color: blue;
    }
}

/* The CSS outputted after transpilation */
li {
    font-size: 2em;
}
li a {
    color: blue;
}
```

Notice that the output of the transpiled code resembles the CSS code we wrote in the first example.

There is no limit to how many items that can be nested, but it is recommended not to nest more than three layers deep since it can be hard to follow the path of the selectors and in most cases, it is not necessary to target that specific nested elements. So a better approach would be to check if the selected element can be targeted in a selector that is a maximum of three layers deep.

## Import

Import is a functionality implemented in both CSS and Sass. Import allows the procedure of taking a CSS or a Sass code file and import it into your current file. The code that got imported will be placed at the import statement. 

The benefit of using Sass over CSS is that every time you import in CSS an HTTP request is made to retrieve the requested file. Using Sass the transpiler adds the code from the imported file to the file with the import state under the transpilation phase, so no HTTP requests are made at runtime.

To import a file we use the @import statement followed by the name of the file that we want to import. 

```css
@import 'my-file-to-import';
```

If you ever want to import a Sass file from another folder this can be achieved using the following syntax when importing the file.

```css
/* Get file from sub folder */
@import '../my-folder/my-file'

/* Get a file from a folder under same folder */
@import './my-folder/my-file'
```

## Mixins

A mixin in Sass is the idea of taking a bunch of CSS selectors and grouping them together into a single statement. The statement can then be used in multiple places reducing some tedious work as well as duplication. An example of tedious work would be to declare vendor prefixes, often requiring typing three or four properties to produce one style in multiple browsers.

To create a mixin we make use of the **@mixin** keyword followed by the name of the mixin. Inside of the mixin, we declare the properties that we want to group together. To use the mixin we use the **@include** keyword followed by the name of the mixin we want to include in the selector.

```css
/* The Sass code */
@mixin grid {
    display: -ms-grid; /* IE 10 */
    display:     grid;
}

body {
    @include grid;
}

/* The CSS outputted after transpilation */
```

It is also possible to use parameters as part of the mixin. The syntax should look very familiar to declaring a function in JavaScript. The important part is to use '$' symbol as part of the parameter name, else the transpiler won't know that it is a variable and would consider it to be a value.

```css
/* The Sass code */
@mixin transform-rotate($degrees) {
    -webkit-transform: rotate($degrees); /* Ch <36, Saf 5.1+, iOS < 9.2, An =<4.4.4 */
    -ms-transform: rotate($degrees); /* IE 9 */
    transform: rotate($degrees); /* IE 10, Fx 16+, Op 12.1+ */
}

body {
    @include transform-rotate(30deg);
}

/* The CSS outputted after transpilation */
body {
    -webkit-transform: rotate(30deg);
    -ms-transform: rotate(30deg);
    transform: rotate(30deg);
}
```

## Inheritance

Inheritance is often mentioned in object oriented programming as being able to inherit the properties of another object. In Sass inheritance can be thought of as the same. Inheritance in Sass enables the possibility of deriving all of the properties of another selector.

To extend a selector use the **@extend** directive followed by the name of the selector that is to be extended. The following example shows how the @extend directive can be used to reduce the amount of code that is required for creating two new buttons with a shared selector.

```css
/* The Sass code */
.btn {
    border-radius: 4px;
    padding: 10 20px;
    color: black;
}

.btn-green {
    @extend .btn;
    background-color: green;
}

.btn-blue {
    @extend .btn;
    background-color: blue;
}

/* The CSS outputted after transpilation */
.btn, .btn-green, .btn-blue {
    border-radius: 4px;
    padding: 10 20px;
    color: black;
}

.btn-green {
    background-color: green;
}

.btn-blue {
    background-color: blue;
}
```

## Operators

Often you will find yourself in the need of using math to correctly modify your selectors. Sass comes with a few standard math operators, **+**, **-**, *****, **/** and **%**. 

In the example below, we manipulate the variable **$font-size** depending on the screen width of the device. The nice thing about this approach is that we can change the value of the $font-size variable, and the math operations will be the same, giving a consistent feel in the development process, even if the value of the variable changes. 

It is important not to mix values. If two values that are incompatible are being used in the same operation, an error will be thrown.

```css
/* The Sass code */
$font-size: 50px;

body {
    font-size: $font-size;
}

@media screen and (min-width: 960px) {
    body {
    font-size: $font-size / 2;
    }
}

@media screen and (min-width: 768px) {
    body {
    font-size: $font-size / 4 + 5px;
    }
}

/* The CSS outputted after transpilation */
body {
    font-size: 50px;
}

@media screen and (min-width: 960px) {
    body {
    font-size: 25px;
    }
}
@media screen and (min-width: 768px) {
    body {
    font-size: 17.5px;
    }
}
```
