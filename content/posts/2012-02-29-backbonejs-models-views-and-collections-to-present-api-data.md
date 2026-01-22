---
title: Backbone.js Models, Views and Collections to Present API Data
slug: backbonejs-models-views-and-collections-to-present-api-data
published_at: '2012-02-29'
author: pixelhandler
tags:
- Backbone.js
meta_description: This tutorial explores coding with [Backbone.js][backbone] using
  data stored in an API. The code developed will interact with an API as described
  in the earl...
---

I will start with the end in mind. I'll need a router to **list** the products, a **collection** of data, a **view** to render the list, and a **model** for each data object. (The code examples are found in a [gist][backbone product list gist])

## The Product's Router

**product_router.js**

    PX = window.PX || {};
    // application
    PX.App = Backbone.Router.extend({
        routes: {
            "/": "listProducts",
            "list": "listProducts"
        },
        //initialize: function (options) {},
        listProducts: function () {
            var productsList = new PX.ProductListView({
                "container": $('#container'),
                "collection": PX.products
            });
            PX.products.deferred.done(function () {
                productsList.render();
            });
        }
    });

In the code above I am using a object named 'PX' as a namespace, adding the code for the Backbone objects to the PX object to minimize adding a bunch global variables to the window obejct. For the purpose of this tutorial I am only adding one global object, 'PX'.

    PX = window.PX || {};

The object literal `{ ... }` is an argument to `Backbone.Router.extend` which is the **prototype** for the router object that I will use to render the products' list. `PX.App` is a constructor with a prototype that extends the `Backbone.Router` function. The prototype (object literal) has to properties: *routes* and *listProducts*. The routes property has an object literal with two named routes - the root directory "/" and "list". Both routes are assigned a string which is the name of the function that handles the routes. See the [Backbone.Router documentation][backbone router] for more details.

In the routes' handler method (`listProducts`) I create a new `Backbone.View` object using the new operator with `PX.ProductListView` and passing some options as an object literal. Included in the options argument are properties for a `container` and also a `collection`. The container is the jQuery object where I will render the products list or *view*. The collection is a list of products or a collection of product models. Typically with an application that has some output from a server-side script a collection's data would be written into a script element (or bootstrapped) as JSON data so that an AJAX request is not necessary. In this case, I am not using any server-side scripting; so, I will need to fetch a collection (array) of products from an API. Also, I am using a [jQuery Deferred object][deferred] to indicate when the collection is ready. The function `PX.products.deferred.done` accepts functions as arguments which can be executed when the deferred object is resolved. In this example the render method is called when a list of products (collection instance) is populated with models (data).

I have not created a view or a collection yet; to use this router I will need both.

## The Products' View(s)

I will need two types of view objects one to render the list and one for each item in the list. A Backbone view has a model instance as data; and uses a `render` method to parse the JSON data into HTML with using a template, e.g. the [Mustache library][mustachejs] provides a sweet logic-less utility to render JSON using an HTML template (see a [Mustache tutorial][mustache tutorial] with [examples][mustache examples]).

**product_list_view.js**


    PX.ProductListView = Backbone.View.extend({
        tagName: "ul",
        className: "products",
        render: function () {
            for (var i = 0; i < this.collection.length; i++) {
                this.renderItem(this.collection.models[i]);
            };
            $(this.container).find(this.className).remove();
            this.$el.appendTo(this.options.container);
            return this;
        },
        renderItem: function (model) {
            var item = new PX.ProductListItemView({
                "model": model
            });
            item.render().$el.appendTo(this.$el);
        }
    });    


The constructor for the *product list view* above uses an (unordered list) `ul` tag and will be responsible for rendering a list of products. The render method uses an iteration over the object's `collection` to build the list of products. The render method depends on the list view object having a `collection` property. (I should have added a check during initialization and also thrown an error if the constructor is called without an option for the collection.)

When rendering a list, the `render` method calls a `renderItem` method which renders each list item. In the method to render each `li` a variable named `item` is assigned a new `PX.ProductListItemView` instance. This *item* is constructed with a model from the products' collection. The item object is a view instance for each product in the list. Notice the reference to `this.$el`, every Backbone view object has an `el` property and also a jQuery/Zepto object `$el`. Also in the render method, the return value is `this`, which refers to the view object itself. So, when a view is rendered the element can be accessed like so `viewInstance.render().$el`. When this code is executed: `item.render().$el.appendTo(this.$el);` from within the `renderItem` method, the result of rendering the product (item) is appended to the `ul` (this.$el) element with belongs to the product list view instance object.

I will need to create a view to render each item...

**product_list_item_view.js**

    PX.ProductListItemView = Backbone.View.extend({
        tagName: "li",
        className: "product",
        initialize: function (options) {
            this.template = $('#product-template').html();
        },
        render: function () {
            var markup = Mustache.to_html(this.template, this.model.toJSON());
            this.$el.html(markup).attr('id',this.model.get('_id'));
            return this;
        }
    });


The *product list items'* view constructor uses a (list item) `li` tag and during initialization selects some HTML to use as an HTML template. This template will be used to render the JSON data for each product. The template HTML is found on the document within a script element, see below.

**product-template.html**

    <script type="text/template" id="product-template">
            <p><a href="products/{{_id}}">{{title}}</a></p>
        <p>{{description}}</p>
        <p>ID: {{_id}}</p>
    </script>


The HTML template will be used to render the markup; see the code in the render method `Mustache.to_html(this.template, this.model.toJSON())`. To learn more about using Mustache, see: [mustache.js][mustachejs]. The [Underscore] library has a template rendering utility as well, I happen to like the *logic-less* library and syntax that Mustache.js provides. This demonstrates the flexibility of Backbone, I can use whatever methods I choose to render HTML. The template HTML could have been loaded using AJAX and stored as an object, in this example I used a script element. In the template there are placeholders for the JSON object's properties: `{{title}}`, `{{description}}` and `{{_id}}`. The job of the template utility is blending JSON data found in a Backbone model object with a HTML template string.

The `$el` property of the view instance object for the list item is an `li` element, which receives the `markup` as it's HTML content when the code `this.$el.html(markup)` in the render method executes. Using `this.$el` allows for chaining. So, I added an `id` property to the `li` element as well.

To learn more about [Backbone.View objects][backbone view] see the documentation.

There would be no list of products to render without a collection...

## The Products' Collection

The product data exists in an (example) API and is available using a [Web service][ecomapi]; the url to fetch an array of products is '/api/products'. [Backbone collections][backbone collection] can fetch this array, then generate models to add as members of the products' collection. Below is a constructor to generate a collection of product data using an API for the data source.

**product_collection.js**

    PX.ProductList = Backbone.Collection.extend({
        model: PX.Product,
        url: '/api/products',
        initialize: function () {
            this.fetch({
                success: this.fetchSuccess,
                error: this.fetchError
            });
            this.deferred = new $.Deferred();
        },
        deferred: Function.constructor.prototype,
        fetchSuccess: function (collection, response) {
            collection.deferred.resolve();
        },
        fetchError: function (collection, response) {
            throw new Error("Products fetch did get collection from API");
        }
    });
    
    PX.products = new PX.ProductList();


In the `PX.ProductList` prototype there are properties for `model` and `url`. The model property has a constructor object used to generate models as members of the products collection. The url property is the web service that [Backbone.sync][backbone sync] will call to fetch the data. During initialization the product data is fetched and a `deferred` property is initialized which will be resolved during execution of the fetch success handler function. 

Backbone wraps the AJAX success and error handlers and calls the handlers sent following the fetch call. When Backbone calls either handler, two arguments are passed `collection` and `response`. In this example, the `fetchSuccess` method resolves the collection's deferred object and the `fetchError` method throws an error. 

When the router fires the method to `listProducts` the collections' deferred object is used to render the list when the deferred is done (resolved). See the router code `PX.products.deferred.done`; which takes an anonymous function to call the list view's render method, `productsList.render();`.

The collection cannot generate a list of products without a model constructor...

## The Product Model

**product_model.js**

    // model
    PX.Product = Backbone.Model.extend({
        defaults: {
            title: null,
            description: null
        }
    });    


This [Backbone.Model][backbone model] is very simple, it has some defaults defined on it's prototype object: `title` and `description`. The API has a much more data in each product document. However, the purpose of this tutorial is to demonstrate generating a list of products; these two properties do for now. Each model that the collection adds will have all the data provided by the Web service. The List view instance also uses the model instance to get JSON data when rendering each list item. The model object has a method to get the data as an object `.toJSON()` which is not stringified but rather a JavaScript object. The model's data is stored on a property of the model instance named `attributes`. To learn more about [Backbone.Model][backbone model] see the documentation.

All these objects work together to provide a representation of the API data in the format specified using the template and the view instance objects to present HTML within the browser. The server is only providing data as JSON objects. All the HTML rendering is done on the client-side. 

So to kick off the application we need to create an instance of the router and start Backbone.history ...

## Bootstrap the Application

**bootstrap.js**

    // bootstrap
    PX.app = new PX.App();
    Backbone.history.start();


`new PX.App()` returns the instance of the router and `Backbone.history.start()` handles monitoring of the hashchange or HTML5 pushState. When a route is matched in the URL e.g. /#list the assigned function is called to handler the route's behavior. For a demo, see the example API page at [http://ecomapi.herokuapp.com/#list][ecomapi list] (look under the heading 'Product List' you can reset the data with the button 'Add product fixtures'). 

See the [Backbone.history documentation][backbone history] for more info.

## Post Hoc

This tutorial walks through development using the core components that Backbone provides; as stated in the Backbone documentation, giving *structure* to a web application. There are more than a few ways to do this same job of rendering a list of products with JSON data. Perhaps event a single AJAX call using a success handler and some DOM manipulation with jQuery. However, without structure in a web application, the task of managing code as the application's life matures and grows (well into a beast) can become a fairly difficult. Backbone provides simple structure and still allows the developer to decide how to organize code, and which utilities to add. I like to use jQuery, Mustache and RequireJS as well, Backbone does not get in the way. See a [sample application][app-boilerplate] using these libraries. I used this sample application to test the file structure and build process when planning development for a fairly complex application.

Perhaps you can continue building upon this tutorial and generate a route to view product details. Also, if you have not already read the first article in this series, you can build your own development API as well - [Develop a RESTful API Using Node.js With Express and Mongoose][productsapi].

In the next post I plan to take a second look at this same code; but instead, walk though the process of using [Jasmine][jasmine], a behavior-driven development framework, to discover the implementation. This tutorial is structured in the same way I would approach writing tests, sort of a top-down approach beginning with the router instance.

## Reference

* Gist: [Product API example using Backbone.js Models, Views and Collections][backbone product list gist]  
* API tutorial: [Develop a RESTful API Using Node.js With Express and Mongoose][productsapi]  
* [Sample API with list generated using code in this tutorial][ecomapi list]  
* [Backbone documentation][backbone]  
* [Underscore documentation][underscore]  
* Framework for API: [Express, a node package for developing node.js apps][expressjs]  
* [hashchange][hashchange] | HTML5 [pushState][pushState]  
* [Mustache examples][mustache examples] | [Mustache tutorial][mustache tutorial]  
* [Example application structure with RequireJS and Backbone.js][app-boilerplate]  

[backbone product list gist]: https://gist.github.com/1912291 "Product API example using Backbone.js Models, Views and Collections"

[productsapi]: http://pixelhandler.com/blog/2012/02/09/develop-a-restful-api-using-node-js-with-express-and-mongoose/ "Develop a RESTful API Using Node.js With Express and Mongoose"

[app-boilerplate]: https://github.com/pixelhandler/vertebrae "Example application structure with RequireJS and Backbone.js"

[backbone]: http://documentcloud.github.com/backbone/ "Backbone.js"
[backbone model]: http://documentcloud.github.com/backbone/#Model "Backbone.Model"
[backbone collection]: http://documentcloud.github.com/backbone/#Collection "Backbone.Collection"
[backbone view]: http://documentcloud.github.com/backbone/#View "Backbone.View"
[backbone history]: http://documentcloud.github.com/backbone/#History "Backbone History"
[backbone sync]: http://documentcloud.github.com/backbone/#Sync "Backbone.sync"
[backbone router]: http://documentcloud.github.com/backbone/#Router "Backbone.Router"

[deferred]: http://api.jquery.com/category/deferred-object/ "utility object that can register multiple callbacks into callback queues"

[ecomapi]: http://ecomapi.herokuapp.com/ "Web Service"
[ecomapi list]: http://ecomapi.herokuapp.com/#list "Backbone List of Products generated with API data"

[expressjs]: http://expressjs.com/ "High performance, high class Web development for Node.js"

[hashchange]: http://www.whatwg.org/specs/web-apps/current-work/multipage/history.html#event-hashchange "hashchange"

[jasmine]: http://pivotal.github.com/jasmine/ "Jasmine is a behavior-driven development framework"

[json]: http://www.json.org/ "JSON"

[mongodb]: http://www.mongodb.org/ "MongoDB (from 'humongous') - Document-oriented storage"

[mongoosejs]: http://mongoosejs.com/ "Mongoose is a MongoDB object modeling tool designed to work in an asynchronous environment."

[mustachejs]: https://github.com/janl/mustache.js/ "Minimal templating with {{mustaches}} in JavaScript"

[mustache examples]: http://coenraets.org/tutorials/mustache/ "example code using Mustache"

[mustache tutorial]: http://coenraets.org/blog/2011/12/tutorial-html-templates-with-mustache-js/ "Tutorial: HTML Templates with Mustache.js"

[node]: http://nodejs.org/ "Node.js"

[pushState]: https://developer.mozilla.org/en/DOM/Manipulating_the_browser_history "Manipulating the browser history"

[rest]: http://en.wikipedia.org/wiki/Representational_state_transfer "Representational state transfer"

[underscore]: http://documentcloud.github.com/underscore/ "Underscore is a utility-belt library for JavaScript"