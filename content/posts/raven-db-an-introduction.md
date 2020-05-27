---
title: "RavenDB an introduction"
date: 2016-08-26T16:26:19+02:00
description: "In this blog post, I will make a small introduction to document based database systems. I will talk about the benefits that RavenDB has over other database systems. In the last section of the blog, I will guide you through a simple console application using RavenDB, and talk about some of the overall concepts you need to know to start working with RavenDB. This blog post will not be a detailed guide using best practices, but rather an overall introduction to RavenDB."
---

# RavenDB an introduction

RavenDB is a good choice for .NET developers that want to use a document database. RavenDB comes with a great library for development in .NET with C#. The library can be downloaded with NuGet package manager.

In this blog post, I will make a small introduction to document based database systems. I will talk about the benefits that RavenDB has over other database systems. In the last section of the blog, I will guide you through a simple console application using RavenDB, and talk about some of the overall concepts you need to know to start working with RavenDB. This blog post will not be a detailed guide using best practices, but rather an overall introduction to RavenDB.

## Document database vs Relational database

To understand the difference between a relational database and a document database we will have to look, at why the relational database was first created and what problem the database system tried to solve.

## History of the relational database

Back in the day’s computer storage was very expensive, so relational databases were created to solve the problem that companies had with expensive storage hardware. The relational database solved this by creating relations between data, so multiple data sets could reference the same data and by that eliminate duplicated data. Reading wasn’t as important as writing to the database, because of that the developers decided to make writes faster than reads, but in a modern day application reads are much more frequent than writes and the users are used to a very fast response time doing reads, therefore the databases should be optimized for reads rather than writes in most modern applications.

The relational database was not created to be scalable, it was meant to run only on a single node. Developers have tried to solve this problem by using sharding, but the solution is still not very great, and trying to scale a relational database is not very easy and requires a lot of work.

Before I stop talking about the problems with relational database systems I have one more point to make. Relational databases systems are very slow when it comes to retrieving data from the database, the reason is that a lot of modern applications use object oriented mappers (ORM’s), to map the data from the relational database to an object-oriented language, to achieve the conversion many joins are needed, meaning that the application is very slow if trying to retrieve data involving many relations requiring a lot of joins. When all that is said, relational databases are great in a sense that they’re very tested and is a very mature technology, most developers know how a relation database works.

Relational database systems have been an industry standard for a long time and has been that because it is a very solid database, but many of the modern applications dealing with huge amount of data require a new type of database system to solve their needs, that is why RavenDB was created.

## RavenDB is a document database

RavenDB is a document database, this means that it saves its data in a document rather than in a table. The data is structured in JSON(JavaScript Object Notation) format. A RavenDB document looks like the following:

```json
{
    "ExternalId": "VICTE",
    "Name": "Victuailles en stock",
    "Contact": {
        "Name": "Mary Saveley",
        "Title": "Sales Agent"
    },
    "Address": {
        "Line1": "2, rue du Commerce",
        "Line2": null,
        "City": "Lyon",
        "Region": null,
        "PostalCode": "69004",
        "Country": "France"
    },
    "Phone": "78.32.54.86",
    "Fax": "78.32.54.87"
}
```

RavenDB retrieves its type information from its own data, this means that if the data is in quotes then it is a string and if it says true or false it a boolean and so on.

All related information is in the same document and there are no tables as there would be in a relational database with a foreign key to connecting them, so that allows all instances of data to be different from each other.

The good thing about all instances of data not being required to be of the same type is that it is easy to change the database schema in the future, this is very popular in applications where requirements change rapidly all the time(modern web applications).

RavenDB is created to scale, it is a lot easier to scale a document database, because there are no relations, so all you need to do is to spin another RavenDB instance up and you’re good to go.

RavenDB is optimized to make reads faster than writes, so when you’re reading from the database it will be very quick, a thing to remember is that all related that is in a single document, meaning that it never has to “join” anything, a single element is loaded and you will be ready to work with the object in your object oriented language very fast without multiple trips to the database.

## Installing RavenDB

To install RavenDB go to the following link [https://ravendb.net/downloads](https://ravendb.net/downloads) and download the zip file (Stable version (3.0.30151)) and unpack it in a folder of your choice.

Go into the folder that you unpacked the files and click on the ‘start.cmd’ file, this will start RavenDB as a local process on your computer and automatically open a browser window.

The browser window that opens will be the place where you manage your raven databases, it will by default run on 8080\. (If the port is already in use it will most likely be port 8081.)

If you did the steps correctly you will now have a window looking like this:

![Shows the control panel of raven database manager](/blogpost/c2bb5e70-fdbc-4297-8340-ff575c424f73.png)

Next step is to create a database. To do that you simply just type a database name into the ‘Name’ field and press Create. In this example, I named it “ExampleDb”. You will now be redirected to a new page, you can **minimize** the browser window and the console window.

## Connecting to RavenDB

RavenDB is now up and running and we have created a database, and we can now start using the database.

Create a new application and name it what you like. I will use a .NET 4.6 console application.

When the console application has been created the next step is to install the ravendb.client package, this can be done by either using NuGet package manager and search for ‘ravendb.client’ and install the package or open your NuGet console and type install-package ravendb.client this will install the RavenDB library.

 ![Displays the nuget package interface for ravendb package download](/blogpost/5d86f62c-524f-4532-b02f-13837ec7b2c1.png)

When the library has been downloaded we can save our first object. I’ve created two simple models, a Product, and a ProductGroup:

```C#
namespace ExampleRaven
{
    public class Product
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string ProductGroup{ get; set; }
    }
}

namespace ExampleRaven
{
    public class ProductGroup
    {
        public string Id { get; set; }
        public string Name { get; set; }
    }
}
```

If you want to use my models you can or you can create your own if you want to store something different.

One thing to notice about the models are that the Product holds a ProductGroup, but it is not set as a reference to the ProductGroup object rather it is set to an Id of ProductGroup as a string, and in RavenDB by default ids are strings.

Because RavenDB is a document database, all the ProductGroup data would be in the same document as if Product referenced to the ProductGroup object directly, so in most cases, it is better to store the “reference” as in id, so you can load the ProductGroup on the Id if you ever have to.

## Creating the Store

To connect to the database we will need to create a document store. A document store holds the connection string and the configuration that can be set dealing with communication between the client and the database.

Creating the store is very simple. In the following example, I am using lazy loading to create the document store, it can be done in a simpler way, but this would be good practice to make sure that only a single instance of the document store is being created. If you don’t want to use the lazy loading way of doing it, you can create a singleton that deals with creating the object.

```C#
using System;
using Raven.Client;
using Raven.Client.Document;

namespace ExampleRaven
{
    public class DocumentStoreHolder
    {
        private static readonly Lazy<IDocumentStore> _store = new Lazy<IDocumentStore>(CreateDocumentStore);

        private static IDocumentStore CreateDocumentStore()
        {
            var documentStore = new DocumentStore()
            {
                Url = "http:// localhost :8080",
                DefaultDatabase = "ExampleDB"
            };

            documentStore.Initialize();

            return documentStore;
        }

        public static IDocumentStore Store => _store.Value;
    }
}
```

Now that the document store has been created, we can use it.

So next step is to store a collection of ProductGroup into the database. In the code below we have created a collection of product groups, the thing to look at is how we store the data.

First, we get the DocumentStore from the implementation we did before, next we  open a session by using the DocumentStore variable and call the OpenSession method, this will return a session object, the session object is used when sending and retrieving data.

To store the data you have to use the session object Store method and pass in the object, but you cannot pass in the collection, you will have to loop through the collection and save the object individually. If you ever find yourself in a situation where you have a lot of objects to save at the same time, use the bulk insert method instead.

The last thing to do to save the objects is to use the SaveChanges method on the session object. When that is done you can run your application and the ProductGroups will be saved to the database.

```C#
using System.Collections.Generic;

namespace ExampleRaven
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var documentStore = DocumentStoreHolder.Store;

            var productGroups = GetProductGroups();

            using (var session = documentStore.OpenSession())
            {
                foreach (var productGroup in productGroups)
                {
                    session.Store(productGroup);
                }
                session.SaveChanges();
            }
        }

        private static IEnumerable<ProductGroup> GetProductGroups()
        {
            return new List<ProductGroup>
            {
                new ProductGroup { Name = "Meat" },
                new ProductGroup { Name = "Diary" },
                new ProductGroup { Name = "Corn" }
            };
        }
    }
}
```

If the code ran successfully you will have the following data showing in your RavenDB studio.

 ![Shows the RavenDB interface with data](/blogpost/e07c82f0-91aa-4795-afbf-604cc0467b69.png)

The last thing to do is to connect the Products to the ProductGroups to see them “reference”each other.

In the following code I’ve deleted all of the code from main, you can do the same if you want. This guide is not to show best practise, but rather a quick introduction to the features of RavenDB, so in a real world application, we would split the code and put it into reusable methods.

```C#
using System.Collections.Generic;
using System.Linq;

namespace ExampleRaven
{
    public class Program
    {
        public static void Main(string[] args)
        {
            SaveProducts();
        }

        private static void SaveProducts()
        {
            var documentStore = DocumentStoreHolder.Store;

            using (var session = documentStore.OpenSession())
            {
                var productGroups = session.Query<ProductGroup>().ToList();

                var products = new List<Product>
                {
                    new Product { Name =  "T-Bone", Price = 30, ProductGroup = productGroups[0].Id},
                    new Product { Name = "Milk", Price = 5, ProductGroup = productGroups[1].Id},
                    new Product { Name = "Flour", Price = 15, ProductGroup = productGroups[2].Id}
                };

                foreach (var product in products)
                {
                    session.Store(product);
                }

                session.SaveChanges();
            }
        }
    }
}
```

The code now opens a session again, inside of the session we use the Query method to get all the ProductGroups out of RavenDB, inside of the Query method you’re also able to make expressions with linq.

Next we create a list of customers and add the ProductGroupId’s to the Products, next we save them to the database. The result on RavenDB studio will look like the following.

The result on RavenDB studio will look like the following.

 ![Product with products groups](/blogpost/6b3d7194-9a92-4335-9295-747670635089.png)

If we look at the picture we can see that Products contains ProductGroups. So it now has a reference.
