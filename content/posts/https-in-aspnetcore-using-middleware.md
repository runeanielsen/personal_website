---
title: "HTTPS in ASP.NET Core using Middleware"
date: 2017-07-10T16:26:19+02:00
description: "HTTPS is now a common practice when hosting web applications. In this blog post, I will show you how to enforce SSL in an ASP.NET Core application using only middleware."
---

# HTTPS in ASP.NET Core using Middleware

HTTPS is now a common practice when hosting web applications. In this blog post, I will show you how to enforce SSL in an ASP.NET Core application using only middleware.

The blog post will be based on an empty ASP.NET Core 1.1 application created using the empty template in Visual Studio 2017.

![Shows the interface for creating an Empty ASP.NET Core solution](/images/blogpost/9dcea12d-8ffd-438a-9c78-5f04a789b457.png)

The following dependencies will, therefore, be installed by default.

```xml
<ItemGroup>
    <PackageReference Include="Microsoft.ApplicationInsights.AspNetCore" Version="2.0.0" />
    <PackageReference Include="Microsoft.AspNetCore" Version="1.1.2" />
</ItemGroup>
```

## Setup

To enforce SSL we need to get the following package.

```xml
<PackageReference Include="Microsoft.AspNetCore.Mvc" Version="1.1.2" />
```

The reason for the requirement of the package is that we need the MvcOptions object to configure the requirement for SSL. To use the object go into the "Startup.cs" file and inside of the "ConfigureServices" method add the following code, so the whole method looks like this. The configuration below now requires all requests to use HTTPS.

```C#
public void ConfigureServices(IServiceCollection services)
{
    services.Configure<MvcOptions>(options =>
    {
        options.Filters.Add(new RequireHttpsAttribute());
    });
}
```

Now that all requests require HTTPS, we should also implement a redirect rule, so all requests using HTTP get redirected to HTTPS. To do that install the following package. The package enables us to use rewrite middleware, so we can rewrite to HTTPS on HTTP requests.

```xml
<PackageReference Include="Microsoft.AspNetCore.Rewrite" Version="1.0.2" />
```

After the package has been installed, go to the "Configure" method in the "Startup.cs" file and add the following code. 

```C#
public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
{
    var options = new RewriteOptions()
        .AddRedirectToHttps();

    app.UseRewriter(options);
}
```

Now, whenever a request is made on HTTP it gets redirect to HTTPS, and our controllers no longer respond to HTTP requests.
