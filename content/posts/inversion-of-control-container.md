---
title: "Inversion of Control Container"
date: 2016-06-26T16:26:19+02:00
description: "ASP.NET Core comes with a build in inversion of control container. In this post, I will introduce the concept of inversion of control and show how to use the build in container in ASP.NET Core to handle the dependencies of your application."
---

To get straight to the facts, we use an IoC container because it help us to decouple our classes and make our life easier when it comes to unit testing. An IoC container is in most cases a framework that will help you manage your classes/objects, this includes creation, destruction, managing the lifetime of the objects and dependencies.

So the basic idea behind inversion of control is that, instead of making your application tightly coupled by letting your classes new up their dependencies, you instead pass in dependencies during class construction and the IoC container framework will take care of the creation of the object and not the classes themselves.

To get most out of this idea you will have to create a structure in your application that supports the use of this. A great way is to make use of Dependency Inversion Principle(DIP) from Robert C Martin’s SOLID principles.

DIP states the following:

* High-level modules should not depend on low-level modules, both should depend on abstractions.
* Abstractions should not depend on details. Details should depend on abstractions.

The way to implement this is by using interfaces as an abstraction layer. An example of this can be seen below, where our CustomerController implementation depends on ILogger which is an interface and the Logger class is the concrete implementation that is being passed into the CustomerController.

![Diagram over dependency inversion principle](/blogpost/48edc857-8c84-4812-b5ac-243d24acfd9c.png)

So instead of passing in concrete implementations we will make use of DIP and inject abstractions instead. This will give us the benefit that we can change the higher level modules implementation of Logger anytime we want, and therefore make our application not tightly coupled to the Logger class, but instead, depend on an abstraction of ILogger.

This will greatly help us when it comes to creating mocking objects for unit testing and if we ever want to change the solution, like using another logging framework.

## IoC Container Frameworks

There are currently a lot of IoC container frameworks available for use. I am mainly a .NET developer, so I will introduce you to a few that are available for the .NET platform.

* Unity
* Is an IoC container developed and maintained by Microsoft
* Autofac
* Open source IoC container framework
* Ninject
* Open source IoC container framework

Overall it doesn’t matter which framework you pick, they all do pretty much the same thing. The reason to pick one over the other would be because you like one of the frameworks syntax better than the others.

## Autofac IoC Container Framework

So I have used all of the IoC frameworks above, but I like Autofac the most, so that will be the framework I will show an implementation of in this section. [Link Autofac.](http://autofac.readthedocs.io/)

I will be making a simple console application, using very little logic as the main goal of this post is to make an introduction to IoC containers, showing the power of the IoC container frameworks. The way you use an IoC container might, therefore, be different depending on which application type you wish to create.

To start using Autofac in your solution you need to install the Autofac package, this can be done by using NuGet package manager console and by typing. _(I will be using version 3.5.2 of autofac)_

``` sh
install-package autofac
```

When you have installed the package, we will start configuring the solution. I personally like the most to create a separate file to store the configurations in.

```C#
using Autofac;

namespace ExampleContainer
{
    public class ContainerConfiguration
    {
        public static IContainer Setup()
        {
            var builder = new ContainerBuilder();

            builder.RegisterType<Logger>().As<ILogger>();
            builder.RegisterType<Writer>().As<IWriter>();

            return builder.Build();
        }
    }
}
```

The thing to notice in this code is that we’re creating a ‘ContainerBuilder’ oject, the container is the place where we will map the interfaces to the concrete implementations. In this example, we have an ‘ILogger’ abstraction and the concrete implementation is the ‘Logger’ class and the ‘IWriter’ concrete implementation is the ‘Writer’ class.

In the last part of the ‘ContainerConfiguration’ class, we create the new container with the component registrations that have been made and returns it. We I can now call the ‘ContainerConfiguration’ class static method ‘Setup’ and get the container.

```C#
using Autofac;

namespace ExampleContainer
{
    public class Program
    {
        private static IContainer Container { get; set; }

        private static void Main(string[] args)
        {
            Container = ContainerConfiguration.Setup();

            UseCustomerController();
        }

        public static void UseCustomerController()
        {
            using (var scope = Container.BeginLifetimeScope())
            {
                var customerController = new CustomerController(scope.Resolve<ILogger>());

                customerController.CreateCustomer("Peter", "90902525");
            }
        }
    }
}
```

So in the code, we get the ‘Container’ and set it as a private static variable. Then we call the ‘UseCustomerController’ method which is a custom method I’ve made just to show an execution of the code. The thing to notice here is the ‘Container.BeginLifetimeScope’ method in the ‘using’ statement. The ‘lifetimescope’ is needed because doing application execution we need to resolve the components that has been registered, so they can be created and dependency injected correctly.

You can if you want, resolve the container components manually directly from the container, but this can lead to memory leaks and a lot of objects hanging around, so it is better to create a child scope in a using statement, so it can be disposed when it is done. So in the next line, we create a new ‘CustomerController’ object which is my own implementation and we resolve the ‘ILogger’ component.

Here is the ‘CustomerController’ implementation, where you can see that the ILogger is being injected in.

```C#
namespace ExampleContainer
{
	public class CustomerController
	{
	   private readonly ILogger _logger;

	   public CustomerController(ILogger logger)
	   {
	       _logger = logger;
	   }

	   public void CreateCustomer(string name, string mobileNumber)
	   {
	       _logger.Log($"Customer Created {name} {mobileNumber}");
	   }
	}
}

```
    
The thing is that the ‘Logger’ class needs an IWriter to function, as you can see in the code below, but we don’t want to resolve this, why?

```C#
namespace ExampleContainer
{
    public class Logger : ILogger
    {
        private readonly IWriter _writer;

        public Logger(IWriter writer)
        {
            _writer = writer;
        }

        public void Log(string message)
        {
            _writer.Write(message);
        }
    }
}
```

Autofac takes care of the resolving the child classes injections so you don’t have to write the code to manually resolve it, only the “highest” class.

This is the sequence of what is occurring behind the scenes.

* CustomerController asks for an ILogger
* Autofac sees ILogger maps to Logger and creates it
* Autofac sees that the Logger needs an IWriter in its constructor
* Autofac sees that IWriter maps to Writer and creates it
* Autofac uses the new Writer instance and finishes the construction of the Logger
* Autofac returns the fully created Logger for CustomerController to use

So if we run the application now we will see the following:

![Console window displaying the output](/blogpost/cc14547f-eac5-441d-8f68-b77c710200d6.png)

So if we ever want to change the implementation of either ‘Writer’ or ‘Logger’ we can change it in the ‘ContainerConfiguration’ file and it will work without having to change the implementation in any of the other classes. One thing to mention is that creating the container manually is not seen as good practice, so the right way is to use an integration library, which I will show in another post.

By using an integration library we won’t have to resolve the components manually, and it will greatly reduce the code configuration code we have to write.
