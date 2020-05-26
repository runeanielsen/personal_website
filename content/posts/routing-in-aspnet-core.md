---
title: "Routing in ASP.NET Core"
date: 2016-09-09T16:26:19+02:00
description: "ASP.NET Core is starting to be a good choice for new web projects. In this post, I will show you how to make a simple route in an empty ASP.NET Core application."
---

ASP.NET Core is starting to be a good choice for new web projects. In this post, I will show you how to make a simple route in an empty ASP.NET Core application.

Start by creating a new solution as shown below, so choose “Web” and pick the ASP.NET Core Web Application (.NET Framework).

![Display NuGet package manager](/blogpost/41dfe83d-7db6-4135-b72d-ae3d5b0497ba.png)

When your solution is ready, go to the project.json file, it is the file where all your project dependencies will be in. Add “Microsoft.AspNetCore.Mvc”: “1.0.0-rc2-final” (or the newest version) so your dependencies should look like the code below.

```json
"dependencies": {
    "Microsoft.AspNetCore.Server.IISIntegration": "1.0.0-rc2-final",
    "Microsoft.AspNetCore.Server.Kestrel": "1.0.0-rc2-final",
    "Microsoft.AspNetCore.Mvc": "1.0.0-rc2-final"
}
```

When you save the solution the dependencies will automatically be downloaded and added to the project.

Next, go into your Startup.cs file. Go to the “ConfigureService” method and add the following code so it looks like the code below.

```C#
public void ConfigureServices(IServiceCollection services)
{
    services.AddMvc();
}
```

The reason that we have to do this is because we need to tell our dependency injection container (IServiceCollection), that we want to use MVC and therefore bind it to the container.

When that is done, go down to the “Configure” method in the same file, and remove the default code and add the following.

```C#
public void Configure(IApplicationBuilder app)
{
    app.UseMvc(routes =>
    {
        routes.MapRoute(
            name: "Default",
            template: "{controller}/{action}/{id?}",
            defaults: new { controller = "Home", action = "Index" }
        );
    });
}
```

So on the “app” variable we use the “UseMvc” method and pass a lambda expression in which we define our default route. It contains the name of the route, in our case “Default”, the “template” of the route containing a controller, action, and an optional id, and it is optional because the string contains a question mark(?), so if you don’t want it to be optional remove the question mark, and last the “defaults” which will be the route to your homepage.

So now you can go and create a controller and an action, and your application should handle the routing.
