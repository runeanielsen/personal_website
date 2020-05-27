---
title: "Webpack 2 bundling using Babel" 
date: 2017-02-05T16:26:19+02:00
description: "Browser compatibility can be a pain and make you not use the new features of JavaScript ES6 and beyond. Luckily there is a savior, Babel. Babel is a way to transpile ES6+ JavaScript code to your version of choice. In this post I will show you have to setup Babel using Webpack 2 to transpile ES6 to ES5 JavaScript."
---

# Webpack 2 bundling using Babel

In my previous blog post, I introduced Webpack 2 and showed how to set up bundling for JavaScript [link](../../../post/webpack-2-bundling-javascript). In this blog post I will show you how to add loaders to Webpack, so you can transpile ES5 and beyond to JavaScript so you can get the benefits of the new syntax without having to worry about browser support.

## Project structure

I've created a simple project with the following files: 

index.html

```html
<head>

</head>
<body>
    <script src="build/bundle.js"></script>
</body>
```

package.json

```json
{
    "name": "webpack-guide",
    "version": "1.0.0",
    "description": "",
    "main": "index.js",
    "scripts": {
    },
    "author": "",
    "license": "ISC",
    "devDependencies": {

    }
}
```

webpack.config

```js
const path = require('path');

const config = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'build'),
        filename: 'bundle.js'
    }
}

module.exports = config;
```

/src/index.js

```js
import sum from './sum'

const total = sum(10, 5);

console.log(total);
```

/src/sum.js

```js
const sum = (a, b) => a + b;

export default sum;
```
    
When you're done setting up the project then install the packages with the command "npm install" furthermore run the script "npm run webpack". If the solution has been set up correctly, then you get the following file "bundle.js" in your "build" folder after running the command. 

## Adding loaders

If you're new to webpack, loaders are a way to preprocess files as they're being loaded. Loaders are a way to handle frontend build steps. We will in this case use loaders to process Babel. 

In your CLI (command line interface), install the following packages:

```sh
npm install --save-dev babel-core babel-preset-env babel-loader babel
```

**The packages are needed for the following:**

*   babel package is for turning ES6 code into readable vanilla ES5.
*   babel-core is the compiler for Babel.
*   babel-preset-env is a package that can automatically determine the Babel plugins and polyfills.

Next step is to add the loader to the webpack config file. First, add a new object named "module" which contains an object named "rules". The rules object is an array and inside of the array, we add our loaders. In the example, we can see that a rule contains three properties, "test", "exclude" and "loader". The test specifies a regex pattern for files to process.

In the loader, we look for JavaScript files, therefore, files with the extension of ".js". Next, we say that we don't want to process any file we reference which is loaded from the "node_modules" folder, this is to make sure that we don't process any dependencies to reduce the chance of bugs. At last, we set the loader to use the "babel-loader", to tell webpack which loader should process the JavaScript files.

```js
const path = require('path');

const config = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'build'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: 'babel-loader'
            }
        ]
    }
}

module.exports = config;
```

Next, we need to add a file named ".babelrc" in the root folder. The file is needed to configure Babel. Inside of the file, we tell Babel to use the "babel-preset-env". The preset tells Babel to run the latest preset.

```json
{
    "presets": ["babel-preset-env"]
}
```

Next just run "npm run webpack" and the code should now be transpiled. If everything worked out, the "bundle.js" file should now contain the following output in the bottom of the file.

```js
"use strict";

Object.defineProperty(exports, "__esModule", {
    value: true
});
var sum = function sum(a, b) {
    return a + b;
};

exports.default = sum;

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var _sum = __webpack_require__(0);

var _sum2 = _interopRequireDefault(_sum);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var total = (0, _sum2.default)(10, 5);

console.log(total);
```
