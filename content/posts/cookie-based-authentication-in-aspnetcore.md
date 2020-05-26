---
title: "Cookie Based Authentication in ASP.NET Core"
date: 2017-12-01T16:26:19+02:00
description: "ASP.NET Core comes with a cookie middleware system that can be used without ASP.NET Core Identity. The reason to use cookie authentication instead of ASP.NET core identity is that you want to provide your own database and login implementation."
---

ASP.NET Core comes with a cookie middleware system that can be used without ASP.NET Core Identity. Cookie authentication lets you provide your own database and login implementation.

Cookie authentication works by creating a user principal and serialize it into an encrypted cookie. Then on request ASP.NET validates the cookie and recreates the principal and assigns it to the HttpContext.

This post will go over the implementation of cookie based authentication in ASP.NET Core 1.0 and 1.1\. ASP.NET Core 2.0 has a new implementation of cookie based authentication.

## Setting up the middleware

Start by adding the following dependencies to your solution. This can be done either by using the NuGet-Package manager interface or by utilizing the package manager console.

```sh
Install-Package Microsoft.AspNetCore.Authentication.Cookies
Install-Package Microsoft.AspNetCore.Mvc
```

Download the NuGet packages and go to the "Startup.cs" file. Inside of the "Startup.cs" file, find the method named **Configure.** Add the following code to set up the middleware. <span style="text-decoration: underline;">You are not required configure the middleware exactly as shown below, you should configure it to suit your needs</span>.

```C#
app.UseCookieAuthentication(new CookieAuthenticationOptions()
{
    AuthenticationScheme = "MyCookieMiddlewareInstance",
    LoginPath = new PathString("/Account/Unauthorized/"),
    AccessDeniedPath = new PathString("/Account/Forbidden/"),
    AutomaticAuthenticate = true,
    AutomaticChallenge = true
});
```

A short overview of the cookie middleware configurations used in the example above.

*   **AuthenticationScheme** - defines the name of the cookie middleware instance. The name will be used when a user is logging in or logging out. 
*   **LoginPath** - is used when a user tries to access a controller with the "Authorized" attribute and is not logged in. The path should redirect to either an error page or the login screen. 
*   **AccessDeniedPath** - specifies what page the user should be redirected to if a user tries to access a page with user rights which do not correspond to the requirements of a specific page.
*   **AutomaticAuthenticate** - indicate whether the cookie should be validated on each request and build a new principal.
*   **AutomaticChallenge** - this flag indicates if the middleware should redirect the browser to the LoginPath or AccessDeniedPath on failed user authentication.

If you want to follow along add the code below to the **ConfigureServices** method inside of the "Startup.cs" file. <span style="text-decoration: underline;">Note that the configurations below are not required to make cookie authentication work.</span>

```C#
services.AddMvc();
```

Also, add the following code to the **Configure** method inside of "Startup.cs".

```C#
app.UseMvc(routes =>
{
    routes.MapRoute(
        name: "Default",
        template: "{controller}/{action}/{id?}",
        defaults: new { controller = "Home", action = "Index" }
    );
});
```

## Implement cookie authentication

The sample below shows a simple implementation of a login and logout functionality. The login method creates two claims, in this case, a name claim is created and a role claim. None of them are required.

The important part is to create claims that you want to identify for each user. The claims are then used to create a claims principal. The claims principal contains all the claims and the authentication scheme that we configured in the middleware.

```C#
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Solution.Controllers
{
    public class LoginController : Controller
    {
        public async Task<IActionResult> Login()
        {
            var claims = new[] {
                new Claim("name", "InsertAccountNameHere"),
                new Claim(ClaimTypes.Role, "InsertRoleHere")
            };

            var principal = new ClaimsPrincipal(
                new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme));

            await HttpContext.Authentication.SignInAsync("MyCookieMiddlewareInstance", principal);

            return Ok();
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.Authentication.SignOutAsync("MyCookieMiddlewareInstance");

            return Ok();
        }
    }
}
```

In the above case, we created an API implementation of login and logout functionality. If you want to use a form control and a submit button with a redirection after a success call, just return a view instead of an HTTP 200 response.

### Validating that it works

To validate that the cookie is being set, navigate to "http://localhost:{your port}/Login/Login". Inside of chrome dev tools under "Application", "Storage" and then to "Cookies", you should now see that the authentication cookie has been assigned.

![](/blogpost/2caa19e4-b248-4196-bd6e-b6b9fc885c10.png)

Next, is to validate that the "Logout" functionality works. Go to "http://localhost:{your port}/Login/Logout" and once again navigate to the Chrome dev tools and look under "Cookies", if everything works as expected the cookie should now be removed.

![](/blogpost/b28c0529-1d27-41bc-9203-cbbbafa846fc.png)

## Using authentication on controllers

To limit a controller to only be accessible to logged in users, you can use the "Authorize" attribute. If the user is not authorized the user will be redirected to the page you specified in the cookie authentication middleware configuration in the "Startup.cs" file.

The attribute can be added to the controller or to a specific method. If you want to only authorize the controller or method to a user with a specific role, you can specify the roles inside the authorize attribute. 

```C#
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Solution.Controllers
{
    [Authorize]
    public class AdminController : Controller
    {
        [Authorize(Roles = "Admin")]
        public IActionResult Index()
        {
            return View();
        }
    }
}
```

If we navigate to the URL "localhost:{your port}/admin" we should be redirected to the unauthorized page specified in the middleware configurations. In this solution, it would be "http://localhost:{your port}/Account/Unauthorized/?ReturnUrl=%2FAdmin".
