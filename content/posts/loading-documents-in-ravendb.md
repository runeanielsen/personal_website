---
title: "Loading Documents in RavenDB"
date: 2016-09-18T16:26:19+02:00
description: "This blog post will address RavenDB. I will show how to retrieve and query documents and then review some technical details about the underlying framework which takes advantage of RavenDB. I will give a short introduction to the session object that is used to load the documents and how to override the default settings of RavenDB document store."
---

This blog post will address RavenDB. I will show how to retrieve and query documents and then review some technical details about the underlying framework which takes advantage of RavenDB. 

I will give a short introduction to the session object that is used to load the documents and how to override the default settings of RavenDB document store.

If you’re new to RavenDB you can read my previous blog post, it is a short introduction to RavenDB. [Link](../../../post/ravendb-an-introduction/ "Introduction to RavenDB")

## Loading a document

To load a document in RavenDB you use the ‘Load’ method on the ‘Session’ object that you get from the document store ‘OpenSession’ method.

The load method is generic, so you will have to specify the type of object that you want to load. If you want to load a type that you haven’t created a class of you can use the ‘dynamic’ keyword to load it without having to implement the class.

The following code shows how loading a document with RavenDB in C# looks like.

```C#
public Customer LoadCustomer()
{
    var documentStore = DocumentStoreHolder.Store;

    Customer customer;

    using (var session = documentStore.OpenSession())
    {
        customer = session.Load<Customer>("customers/1");
    }

    return customer;
}
```

The code is pretty straight forward we open a session on the document store object and use the load method on the session. We load the document based on an Id of type string.

RavenDB creates the id’s itself unless you specify the id on the object. By default, RavenDB uses the plural form of the object name and after that sets an incremented id.

This can be overridden on the document store if you ever want that to change. One thing to consider before starting to override settings on the document store is that you should have a good reason to do it, RavenDB comes with thought out settings, so you must not override them because you can, but if you have a good reason to do it.

## How the Session works when loading documents

The session knows all about the objects it has loaded, this means that if you try to load the same document two times, it will only do a single trip to the database.

It can do this because the session keeps tracks of all the documents you have loaded. When it sees that you’re going to load a document it checks if it already has it loaded. If the session already has the document loaded it will serve that document to you instead of doing another trip to the database. This reduces the amount of remote calls to the server.

The session has a limit of how many remote calls it can do to the database in a single session. It has this because it wants to limit the mistakes that developers can make dealing with the session, the limit is 30 remote calls in a single session. If you try to go over the limit an error will be thrown and you will have to rewrite the code to work with the limit of 30 remote calls.

The setting can be changed if you want to on the document store, but the best choice is to optimize the session to stay inside of the 30 remote calls per session.

In the code below the max number of request per session has been set to 50, this is done by changing the ‘DocumentConvention’ property on the ‘DocumentStore’ object.

```C#
var documentStore = new DocumentStore()
{
    Url = "http://localhost:8080",
    DefaultDatabase = "Northwind",
    Conventions = new DocumentConvention
    {
        MaxNumberOfRequestsPerSession = 50
    }
};
```

You can change a lot of things on the convention object, but I will let you look into that if you’re interested.

## Optimize

A way to optimize the number of remote calls is to know about the features that RavenDB comes with, below are two examples of loading multiple entities on a single remote call.

This example shows loading multiple entities of the same type on ids, using a single remote call to the server.

```C#
public void LoadCustomer()
{
    var documentStore = DocumentStoreHolder.Store;

    using (var session = documentStore.OpenSession())
    {
        var companies = session.Load<Company>(new List<string> { "companies/64", "companies/65", "companies/66" });
    }
}
```

This example shows loading different types of entities in on ids, using a single remote call to the server.

```C#
public void LoadItems()
{
    var documentStore = DocumentStoreHolder.Store;

    using (var session = documentStore.OpenSession())
    {
        var data = session.Load<object>(new List<string> { "companies/64", "products/50", "orders/66" });
        var company = (Company) data[0];
    }
}
```

Because we load the documents as type object, we have to cast it to the proper type. The array that is returned has the elements based on the collection with ids that we inserted. So in our example company/64 is on index 0.

Using strings to get elements out from the database can be a hassle, so you’re also able to load documents based on the integer value of the id, this is great in web scenarios where you would load a document on a single integer value from an HTTP get request.

This example shows loading an entity on an integer value.

```C#
public void LoadItems()
{
    var documentStore = DocumentStoreHolder.Store;

    using (var session = documentStore.OpenSession())
    {
        var product = session.Load<Product>(1);

        Console.WriteLine(product.Name);
    }
}
```

## Include

It is important to keep the number of remote calls that you make on a session to a minimum, a way to achieve that is by using the include method on the session object. Include is one of the main ways to reduce the remote calls to the database.

In most cases, we will make ‘relations’ to other documents by referring to the id of the other document, an example of a document file with a relation to another document looks like the following:

```json
{
    "Name": "Original Frankfurter grüne Soße",
    "Supplier": "suppliers/12",
    "Category": "categories/2",
    "QuantityPerUnit": "12 boxes",
    "PricePerUnit": 13,
    "UnitsInStock": 32,
    "UnitsOnOrder": 0,
    "Discontinued": false,
    "ReorderLevel": 15
}
```

The product document refers to the ‘Supplier’ and ‘Category’ document. If we try to load the product document using the ‘Load’ method and try to display the supplier we will get the following output:

“suppliers/12”

We don’t want to display the identification value, but rather a property of the object. So we would load the supplier right after the product, like the following code.

```C#
public void LoadItems()
{
    var documentStore = DocumentStoreHolder.Store;

    using (var session = documentStore.OpenSession())
    {
        var product = session.Load<Product>(77);
        var supplier = session.Load<Supplier>(product.Supplier);
    }
}
```

This would create two remote calls to the database in a single session, so image having 10 ‘relations’ to other documents on a single object, this would be 10 calls per object. To reduce this we can use the ‘Include’ method.

```C#
public void LoadItems()
{
    var documentStore = DocumentStoreHolder.Store;

    using (var session = documentStore.OpenSession())
    {
        var product = session.Include<Product>(p => p.Supplier).Load(1);
        var supplier = session.Load<Supplier>(product.Supplier);
    }
}
```

The code above looks very much the same as the previous example, but the difference is that we use the ‘Include’ method and pass a lambda expression in and say that the product goes to the supplier.

After the lambda expression, we load the product and the supplier. The code makes it look like we still do two calls to the database. We actually only do a single call, this is what happens behind the scenes:

1.  Find a document with the key: “products/12”
2.  Read its ‘Supplier’ property value.
3.  Find a document with that key.
4.  Send both documents back to the client.

So when we load the product and the supplier we load it directly from the session cache.

## Query the database

Loading documents on ids are great, but in most cases, we don´t want to load documents on ids, but rather query the database and get entities out on specific criteria’s. The query mechanism in RavenDB is built on LinQ so it should look very familiar if you come from the .NET world of ORM’s.

```C#
using System.Linq;

namespace ExampleRaven
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var program = new Program();
            program.LoadItems();
        }

        public void LoadItems()
        {
            var documentStore = DocumentStoreHolder.Store;

            using (var session = documentStore.OpenSession())
            {
                var products = session.Query<Product>().Where(a => a.PricePerUnit > 10);
            }
        }
    }
}
```

The example above should be straightforward, we load the products using the ‘Query’ method on the session and get all the products where the price per unit is bigger than 10\. The items are returned as IEnumerable<Product> and after that, the items can be worked with.

I won’t go much over lambda expressions and LinQ in this post, but just tell that you can query the database like you would query a collection of items using LinQ.
