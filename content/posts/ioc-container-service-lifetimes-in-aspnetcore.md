---
title: "IOC Container Service Lifetimes in ASP.NET Core"
date: 2017-04-01T16:26:19+02:00
description: "When you're building a web application it is important to be able to control the service lifetime of the registrations in your container. The reason is that some of your objects might require being instantiated on every request while another instance should be unique and should only be instantiated once in the application lifespan."
---

ASP.NET Core is designed to support and leverage dependency injection and therefore comes with a built-in inversion of control container (IOC container). If you're new to IOC containers you can read my introduction here [link](/post/inversion-of-control-container).

When you're building a web application it is important to be able to control the service lifetime of the registrations in your container. The reason is that some of your objects might require being instantiated on every request while another instance should be unique and should only be instantiated once in the application lifespan.

To manage the lifetimes you can make use of registration options. ASP.NET services can be configured with the following lifetimes. All of the lifetimes are configured using the **IServiceCollection** interface.

### Transient

The** transient** lifetime services are created each time the service is requested from the container. If multiple consumers depend on the service, each consumer will get their own new instance of the given service. A service should be registered as a transient lifetime if the registered type is lightweight and stateless. 

```C#
services.AddTransient<IPostService, PostService>();
```

### Scoped

When you define the service as **scoped**, then every request within an implicitly or explicitly defined scope will result in a single returned service from the container and that instance of the service will be disposed when the scope ends. 

```C#
services.AddScoped<IUnitOfWork, UnitOfWork>();
```

### Singleton

Using **singleton** there will at most be one instance of the registered service type in the container and the container will hold on to that instance until the container is disposed or goes out of scope. This means that multiple clients will get the same instance from the container. 

```C#
services.AddSingleton<ISitemapService, SitemapService>();
```

## Summary

It is important to correctly register your services lifespan. There are three options to choose from. 

*   Pick transient if each object that depends on the service should get its own instance of the service when requested. 
*   Pick scoped if the instance should only be instantiated once per request.
*   Pick singleton if the service should only be instantiated once and be shared between multiple clients.
