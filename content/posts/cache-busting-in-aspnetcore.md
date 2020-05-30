---
title: "Cache busting in ASP.NET Core"
date: 2017-07-17T16:26:19+02:00
description: "Caching static resources is a good way to improve the performance of your website. Instead of your server having to deliver each static resource on every request. The user's browser caches the static resources the first time that they're requested and received, and thereafter loads them from the cache on the following requests instead of requesting them from the server again. In this post, I will show you how to implement cache busting using ASP.NET Core tag helpers."
---

Caching static resources is a good way to improve the performance of your website. Instead of your server having to deliver each static resource on every request. The user's browser caches the static resources the first time that they're requested and received, and thereafter loads them from the cache on the following requests instead of requesting them from the server again. _To implement static resource caching in ASP.NET Core you can read this blog post [link](/post/response-caching-in-asp-net-core "Response caching in ASP.NET Core")._

The problem with caching static resources is that the user might have cached resources that don't match the files on the server. The caching might not be a big concern when dealing with images but can result in unexpected results when it comes to JavaScript and CSS files. To handle the issue we will have to ensure that the client is always having the latest version of our static files. To do that we will introduce the concept of **versioned URLs**.

## Versioned URL

Versioning a URL is the process of giving a file a unique URL every time the file changes. Giving the file a unique URL prevents the browser from loading the previous version from the cache because it will only load the files from the cache if they match the same URL, that the resource was first requested from.

Three possible strategies are as follows.

*   Query string: **http://mywebsite.io/file.js?v=123**
*   Unique file name: **http://mywebsite.io/file-v2.js**
*   New folder for every version: **http://mywebsite.io/version-2/file.js**

All of the above strategies can be achieved if you're using a task runner like [Gulp](http://gulpjs.com/ "Gulp website") or a module-bundler like [Webpack](https://webpack.js.org/ "Webpack website"), but in this post, I will show you how to use the **first** strategy using ASP.NET Core **tag helpers**.

ASP.NET Core Razor view engine comes with a tag helper named "**asp-append-version**". The tag helper is applied to the resource in the HTML file that should have a versioned URL, to make it work the value "true" should be set on the tag helper.

```html
<script src="~/lib.min.js" asp-append-version="true"></script>
```

By using the tag helper on the resource a randomly generated version number will be appended to the link as a query parameter. The version number generated is unique for every resource and will be generated again when the file changes.

```html
<script src="/lib.min.js?v=Qx4RpgEaEqv4zROQBw9L_zUbUGd9QsLvaIfAsANsPxY"></script>
```

That is actually everything there is to it. Every time you now update your static resource a new version is being appended to the URL and you will no longer have the problem with users having cached resources that do not match the resources being delivered from the server.
