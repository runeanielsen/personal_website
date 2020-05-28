---
title: "Introduction to Fetch in JavaScript"
date: 2017-06-05T16:26:19+02:00
description: "Instead of using the good old XMLHttp Request Object in JavaScript. ES6 introduce the concept of Fetch. Fetch provides a cleaner interface for retrieving resources from both internal, but also external sources. The interface will seem familiar to the XMLHttpRequest, but Fetch has both a more powerful and flexible feature set."
---

# Introduction to Fetch in JavaScript

Instead of using the good old XMLHttp Request Object in JavaScript. ES6 introduces the concept of **Fetch**. Fetch provides a cleaner interface for retrieving resources from both internal, but also external sources. The interface will seem familiar to the XMLHttpRequest, but Fetch has both a more powerful and flexible feature set.

Fetch in its simplest form is a method on the global object that takes in a string. The string should contain the path to the resource, that is to be retrieved.

```js
fetch('path');
```

To execute the fetch, the **then** method is used. The then method takes in a function callback with an optional parameter.

```js
fetch('myUrl.com').then(response => {
    console.log(response);
});
```

The optional parameter is usually named response (you can name it anything you want). The parameter contains an object returned from the fetch method. The most commonly used properties of the response object are the following.

*   **status**
    *   Contains the status code from the HTTP call represented as an integer
*   **statusText**
    *   The status code in text represented as a string. An example of a status text is "Ok" and corresponds to status code value 200
*   **ok**
    *   Is a boolean value and is an easy way to check if the status code returned from the request is in the range of 200-299

An example of a response object from a fetch request can be seen below. 

```js
fetch('https://api.github.com').then(response => {
    console.log(response);
});
```

Resulting in the following data being displayed in the chrome dev tools. Where the **ok** property can be seen as true, **status** as 200 and **statusText** as "OK".

![data from request](/blogpost/6dadb363-8fa3-4420-a19e-f3e2fa3cafee.png) 

The **ok** boolean is very useful when you want to validate that the request was completed successfully.

```js
const requestUrl = 'https://api.github.com';

fetch(requestUrl).then(response => {
    if (response.ok)
        console.log(response);
    else
        console.log(`The request made to ${requestUrl} failed`);
});
```

## Request Options

The second parameter on the fetch method is the request option. Request options are settings that define the behavior of the request created by the fetch method. The most common setting is to set the request method. The request method can be set to either "GET", "POST", "PUT" or "DELETE".

To apply the settings to the request, just pass them to the fetch function as the second parameter.

```js
const initalSettings = {
    method: 'GET'
};

fetch('https://api.github.com', initalSettings).then(response => {
    console.log(response);
});
```

To apply headers to the request, we make use of the **Headers** type. One way to apply the headers is doing object initialization by passing the object to the Headers constructor. Another way is by using the **append()** method on the Headers object. To apply the headers to the request, set them on the property named "headers" on the request settings object. 

The code below shows an example of using the append method to set the 'Date' header to the value of 'Date: Tue, 15 Nov 1994 08:12:31 GMT'.

```js
const headers = new Headers({
    "Content-Type": "text/plain",
    "X-Custom-Header": "myCustomHeader"
});

headers.append('Date', 'Date: Tue, 15 Nov 1994 08:12:31 GMT');

const initialSettings = {
    headers: headers,
    method: 'GET'
}

const requestUrl = 'https://api.github.com';
fetch(requestUrl, initialSettings).then(response => {
    console.log(response);
});
```

The headers object comes with a lot of methods, these are the most commonly used.

*   append
    *   Appends a new header to the Headers object, if the header already exists it sets the value to the one passed to it.
*   delete
    *   Delete a header from the Headers object.
*   get
    *   Returns a string containing all the values of a specific header inside of the Headers object based on the name parameter passed into the method.
*   has
    *   Returns a boolean that tells if the Headers object contains a specific header based on the header name passed into the method.  

## Chaining Promises

When the fetch method is applied, it returns a [promise](/post/promises-in-javascript "Link to promise post"). Promises can be chained, therefore if a series of fetch requests need to be in a precise order this can be accomplished by using the promise returned. 

The example below shows how the fetch promise can be used to chain requests to a resource, where each returned promise is used for the next request.

```js
fetch('https://api.github.com').then(response => {
    console.log('Response one')
    return fetch(response.url);
}).then(response => {
    console.log('Response two')
    return fetch(response.url);
}).then(response => {
    console.log('Response three')
    return fetch(response.url);
}).then(response => {
    console.log('Response four');
    console.log(response);
});
```

The above code results in the following output being displayed in the console window.

![Google console displaying Fetch result](/blogpost/c025258b-70cd-4b27-beab-b1b9c133431f.png)

The code example below shows how the fetch method and promise chains can be used to retrieve data from an external source and handled in a specific order. The code makes sure that each request was handled correctly. If it was handled correctly the next step is to turn it into json and the last step to display the data to the console.

```js
function status(response) {
    if (response.ok) {
        return Promise.resolve(response);
    } else {
        return Promise.reject(new Error('Something went wrong!'));
    }
}

function json(response) {
    return response.json();
}

fetch('https://api.github.com')
    .then(status)
    .then(json)
    .then(data => {
        console.log('Retrieved the following data:', data)
    }).catch(error => {
        console.log('The request resulted in the following error:', error)
    });
```

The above code results in the following being displayed in the console.

![Fetch result from chrome console containing response from github api.](/blogpost/06040e10-5449-4d87-82e7-f8729aae08fa.png)

## Browser Support

Fetch is currently supported in most modern browsers. It is therefore not necessary to bring in polyfills unless a big segment of your user base uses internet explorer or older versions of browsers, it might be a good idea to bring in a polyfill to handle the issue with browser support. You can read more about fetch polyfills here [link](https://github.com/github/fetch "Github Polyfill Fetch page.").

The table below shows the browser support for fetch as of 05-06-2017.

![Diagram over the basic support for fetch.](/blogpost/987a3af3-2cf8-4033-98ea-4641fd93c8d7.png)
