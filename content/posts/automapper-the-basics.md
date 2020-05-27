---
title: "AutoMapper The Basics"
date: 2016-06-06T16:26:19+02:00
description: AutoMapper is a library for the .NET platform, which has the task of mapping an object to another. The usefulness comes when working with views or APIs where data must be presented or sent. In the provided cases, one uses view models for view rendering, or data transfer objects when working with APIs.
---

# AutoMapper the basics

AutoMapper is a library for the .NET platform, which has the task of mapping an object to another. The usefulness comes when working with views or APIs where data must be presented or sent. In the provided cases, one uses view models for view rendering, or data transfer objects when working with APIs.

The usefulness of a mapping framework lies in that you without it would end up with many manual mappings. Manual mappings can be both time-consuming to create, but also easily breakable in case of domain model changes.

To give a short introduction to view models and data transfer objects I will give a quick summary of the use cases and the benefits of using them. The reason for the introduction is to understand the benefits of view models and data transfer object because they are the place where we will most likely use the features of AutoMapper.

A view model is a way to solve the problem, that occurs when your view depends on your domain model directly. That is if your domain model is modified, your view might also have to change, indicating that your view and domain model is tightly coupled. So the benefit of the view model is that your view depends on it and not on the domain object, therefore if the domain model is modified the view is still working. The place to adjust is consequently no longer on the view but in the mapping layer.

Another reason to create a view model or data transfer object is that you don't want to expose all data on your domain object to the user. So your view model or data transfer object only contains the values that you want to display on a given view or returning on an HTTP API request. An example would be an account domain object with both username and password, but you don't want to expose the password to the user, only the username. So you create a data transfer object with only the username property.

In the code below I will show a creation of a view model. The example matches the creation of a data transfer object as well.

Example of simple customer model

```C#
public class Customer
{
    public int Id { get; set; }
    public string Firstname { get; set; }
    public string Lastname { get; set; }
}
```

Example of create customer view model

```C#
public class CreateCustomerViewModel
{
    public string Firstname{ get; set; }
    public string Lastname { get; set; }
}
```

As you can see in the code above, we only want to expose the “firstname” and the “lastname” of the domain model to the user. The “Id” is not created yet, so it doesn't make sense to present it to the user, as it would be the default value of int and would not serve a purpose.

To map this the normal way without AutoMapper, we manually have to assign each property from the view model to the domain model. This is a pretty quick task when dealing with a low amount of properties, but when the number of properties gets high, the mapping becomes a very time-consuming task, and the same mappings will occur in many places. To solve this problem we can use AutoMapper.

An example of manual mapping.

```C#
var customer = new Customer
{
    Firstname = vm.Firstname,
    Lastname = vm.Lastname
};
```

## Installing AutoMapper

To install AutoMapper, use Nuget package manager console and run the following command:

```sh
install-package automapper
```

When AutoMapper is installed we need to create a class to store our mappings.

A good practice is to create this class inside the App_Start folder or to create a separate folder for mappings. If you have a larger application you might want to split the mappings into multiple files, to make the application more maintainable.

## Configuration

To create the configuration of the mappings, you need to inherit from a class named “Profile” in the “AutoMapper” namespace and override the “Configure” method from the base class.

```C#
using AutoMapper;

namespace AutomapperExample
{
    public class MappingProfile : Profile
    {
        protected override void Configure()
        {

        }
    }
}
```

The “Configure” method is where we declare our mappings. To start the configuration of the mapping you need to use the “CreateMap” generic method and specify the domain model to the view model mappings and the other way around. 

```C#
using AutoMapper;
using AutomapperExample.Models;
using AutomapperExample.ViewModels;

namespace AutomapperExample
{
    public class MappingProfile : Profile
    {
        protected override void Configure()
        {
            // From Domainmodel to Viewmodel
            CreateMap<Customer, CreateCustomerViewModel>();

            // From ViewModel to Domainmodel
            CreateMap<CreateCustomerViewModel, Customer>();
        }
    }
}
```

If the mappings are identical you can make use of the "ReverseMap" method, which creates a map for both the view model and the domain model. 

```C#
// Maps both ways
CreateMap<CreateCustomerViewModel, Customer>().ReverseMap();
```

The way that AutoMapper works is that it finds properties with the same type and name and maps the properties that match. When you have created your mappings, you need to initialize the mappings. This is usually done in the “Global.asax” file in the root folder of your project.

Here you specify the mapping profiles you want to initialize. For every mapping profile, you want to use, remember to initialize them. 

```C#
using System.Web.Mvc;
using System.Web.Routing;
using AutoMapper;
 
namespace AutomapperExample
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            Mapper.Initialize(c => c.AddProfile<MappingProfile>());
            AreaRegistration.RegisterAllAreas();
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}
```

## Using AutoMapper.

To use AutoMapper you want to use the static method “Map” on the Mapper class. There are different ways that you can use AutoMapper to map your objects, explained in details below.

### Single mapping with return

When you want to do a mapping on a single object, with a return of either the view model or the model class, you can do it in two ways:

First, you specify what class type that the data comes from, and what type it should map to. When that is done you pass the argument containing an object of the first type specified, in this case, it is a “CreateCustomerViewModel”. The result will be a mapped “Customer” object.

```C#
var customer = Mapper.Map<CreateCustomerViewModel, Customer>(vm);
```

Another way to do the same thing is by only passing the type it should map to, and don’t specify the type that it maps from. It gives the same result as above but in less code. The downside can be that it is harder to see what type it maps to.

```C#
var customer = Mapper.Map<Customer>(vm);
```

### Collection mapping with return

If you want to map a collection of objects you can do it in two ways. The first way is by doing it in the Select Linq statement mapping all of them to a generic list. 

```C#
var vmCustomers = _context.Customers.ToList()
    .Select(Mapper.Map<Customer, CustomerViewModel>);
```

Another example here mapping from an IEnumerable collection of “Customer” to an IEnumerable collection of “CustomerViewModel”. 

```C#
var vmCustomers = Mapper.Map
    <IEnumerable<Customer>, IEnumerable<CustomerViewModel>>(customers);
```

#### So to summarize, AutoMapper is great because:

* AutoMapper makes it easier to map view models to domain models and the other way around.
* If changes happen to the domain object, it is easy to change the mapping profile, and all the code using AutoMapper won’t have to change.
* AutoMapper handles the mapping on view models and domain models that have same names and types.
* It removes duplicate code in case of multiple places that make use of the same mapping convention.
