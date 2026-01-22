---
title: My Battle with Data Persistence in Ember Apps
slug: my-battle-with-data-persistence-in-ember-apps
published_at: '2015-06-20'
author: pixelhandler
tags:
- Ember.js
- Data
- JSON API
meta_description: This post fits well within the purpose of this site, my web log.
  What follows is my personal history (changelog) of battling data persistence in
  JavaScript a...
---

# Project Wars

I worked at an agency on a complex single page application in JavaScript that was a product finder. We built the API so that is was discoverable, parameters came in and choices came out in JSON with URLs for the next available choices or actions. After a few steps, maybe seven or so, the user would have a narrow set of products that met the search criteria and geographic availability. The application loaded JSON files to configure the steps it took to walk the user through the various product finders. The functional spec was in the range of 350 pages, and the project was a MICROSITE. The end result was an order page. There shoppers could begin the purchase process and customize the products' size, to fit the shoppers custom measurements. How did we do this? We used Backbone.js and built all of our application logic on top of it. Just prior to this project I had developed a front-end framework on top of Backbone that did have many similarities to Ember.js. It supported building modular packages with AMD using Require.js. Those were the days of the Wild West, when we rolled our own JavaScript front-end frameworks. Hallelujah, those days are gone. I say, "Good riddance."

JavaScript frameworks provide a way to build; and some will dive into the data layer, while others leave that to the developer. I have to say that, the data side of building single-page (JavaScript) applications is still a lot like that last paragraph, in the Wild West. Building on top of something that mostly works but doesn't answer the direct needs of my application. Basically, building with an alpha/beta library and chasing a solution.


## The Awakening

So after about two years, full-time, of focusing on building applications with Ember.js and doing battle with complex data needs (lots of read/write, multiple users in an app, big data, legacy data, magic data, think of a gem, and simple data)… I am now extremely thirsty for a common specification that works well for applications speaking JSON over HTTP. I'd like a specification, or format, that works really well in a JavaScript application and allows for data services to have the flexibility and freedom to own the data needs entirely. Those data services simply give a representation of resources as the client requests them - as well as provide operations to those resources' attributes, state and relationships via REST. Specifically, I would like the client to have no requirement to duplicate the ORM (Object-relational mapping) or to mimic how the backend maps relations (foreign keys). Ideally, services that provide a solid format for JSON data, are discoverable (provide URLs), and have a pattern for operating on the resources, etc. And of course, without the need to battle over data contracts between client and server (teams).


## The Menace

So back to my history. After building the antithesis of a microsite, I worked on an email application built with Ember. We built an Ember app inside an Ember app for editing an HTML document (email template). We broke down an HTML document and turned it into editable views; then persisted the changed document so that it is ready to merge with data for mail delivery. Ember Data was in its first iteration and had a concept of a transactions, and still needed to define how to work with polymorphic data. The team was an early adopter of Ember.js, pre 1.x. The team fought with bugs in basically alpha software for data persistence but still managed to ship a beta product. Well, it turned out that that the team was not the right fit for me; and I moved on. However, I was able to adopt Ember.js early, before it hit a stable 1.0 release, this made me happy.


## Attack at the Agency

Next, I took a position about 300 miles closer to home but still about 60 miles away. I do like working with Ember.js so tried to continue that effort. This was a small team, who previously built apps with SproutCore, the predecessor to Ember.js. The data relationships were complex, the need was for lots of reading and writing, as well as dealing with sparse record collections. There was a pattern of caching related data to be used in a list view by requesting an incomplete representations of a resource (for large lists) and reloading some records to refresh for detail views. We managed the state of resources in both the client and the server. We embedded snippets of data across various documents, managed the relationships of the data on the client, and we wished for id-only records (to deal with the sparse collections). We persisted collections of related records in batches, and disabled editing during the transaction.

There was the need to overhaul Ember Data and then it happened. The library abandoned transactions and embedded records. We tried to press forward anyway, our data needs did not change, the library changed its feature set. Perhaps the ambition needed to be simplified; we had dreams of a super ambitions data solution. So, we hacked up our feature set on top of the library we chose, Ember Data. We thought that this was the happy path for us.

Also we tried out a move to Ember Model, perhaps a lightweight solution would be sufficient. JSONPatch became appealing to us, as we fought with data inconsistencies from throwing around complete representations of objects asynchronously for both attribute changes and relationship changes. We spent about six months on a fork of an adapter/serializer combination that fixed the embedded records solution for Ember Data. It was a happy day when that work merged back into Ember Data. A sweet win for us and others who had similar needs for embedding records. Then the contract ended, another transition for me - I really wanted to work closer to home. (I have a big family.)


## Big Data Strikes Back

Next, I moved to another early adopter of Ember.js, to work on ambitions applications utilizing big data. The apps consumed a big data set. Some data was input via file uploads, from UI input, and other data was changed/added by another source in the cloud platform - all of the changes require the app to be refreshed. This was another complex data solution using an early version of Ember Data which required a server solution to re-format the data accordingly to the client (data) conventions. Next, we built newer and smaller apps, yet as a collection of tools still ambitions in scope. We abandoned Ember Data for this work and built custom adapters to connect with our data services. With a big set of data… endpoints vary across the platform. Some of our requests require two or more requests to compose the resources in order to hand them off to the client application. We built "thick" client apps that work with many endpoints to capture slices of the large data set.

From these examples, I can see why there is not a single solution for everyone's use cases for data persistence. And why anyone working on a common data persistence solution is required to build a complex abstraction to address so many options to communication JSON resources via HTTP.


## The Return to the Agency

Strange as it may seem, I actually went back to my old job. A friend opened up his seat making a way toward the flexibility I needed with my family and a stretch goal in my career in accepting a management role. I thought I'd never do that. On the microsite project I had a lead role. During that season I hardly wrote any code and ended up frustrated, the deadlines were nutty and the tech debt was steep. I really do like to build stuff, especially web applications. Now, I'm back in LA. I work remote most of the time and lead a small team. We have a handful of Ember apps that have lived for one or two years. These apps use a core library, so there are many shared components/views/controllers for UI needs, including managing large collections of resources. I am really happy :)

We still have a lot of work ahead of us. The apps we work on were sort of built in start-up mode. We need automated tests, this will help us stabilize change - and some refactoring. We'd like to move to [Ember CLI] quickly. We now have Ember 2.0-beta to embrace; so basically there are huge shifts that we need to make on our platform. To move to the new "Ember Way" because Ember 1.x is so last year. By the way, if you thought there was such a thing as an Ember Way, I'm sorry to disappoint you there is no such thing. The Web platform is moving fast these days and Ember.js does strive to skate to where the puck is going. So yeah change happens, well it happens a lot, that's the Ember Way. We usually ride canary or beta versions of Ember then when an app ships track to the current release. Over the past few years our apps made it all the way to 1.10. I've seen others that have not made it that far.

[Ember CLI]: http://ember-cli.com


## More Movie Puns

I have seen a few big Ember apps frozen (I know what you're thinking, "Let it go"). The freeze was due to loads of features that integrate with lots of data (while making big bets on Ember Data). When Ember Data was revamped the first time, there became too much effort to revamp the entire app and freeze shipping user stories. Perhaps it was just unfortunate timing for the product backlog. Just because the library changed, doesn't mean the business was ready to freeze the backlog while overhauling the app's data persistence solution. (To the product owners it sounds a lot like asking "Do you want to build a snowman?").

Maybe my experience is unique; however, I've heard similar stories where a major refactor had to take place, and was required to continue feature development. That makes sense, when the framework/library changes significantly, upgrades should be planned accordingly. Perhaps that is an early adoption tax, par for the course. Also, every project has an end of life; that's the perspective of the long game. One of my business coaches told me, "You always need an exit strategy". So I try to plan for how an app will end and make trade offs accordingly. At times it's ok not to track the current framework release and at other times that would kill the product.


## The Good Bad and the Ugly

Experience teaches me to learn from the good parts… What would my ideal data persistence solution look like? Is there actually one? Or, does the journey always depend on the project requirements? That may be true. Most projects are not done perfectly the first time, maybe the second, or perhaps the third. The Ember Route had three big overhauls and so did the view layer.

Over the past month a few quotes have captured my attention…

“Don't try to be the smartest developer. Instead, be the most tenacious one.  Be the one who doesn't give up until the problem is solved.” –Dana Jones @danabrit  [Jun 4, 2015](https://twitter.com/danabrit/status/606563836007571457)

“Anything worth doing is worth doing poorly until you learn to do it well.” –Zig Ziglar

“Success is when people who don't understand your tool are using it – so you have to plan for that” –@stubbornella [#theMixinJune2015](https://twitter.com/chriseppstein/status/606297381529747456)

As I have considered the idea of starting from scratch I collected a list of what I think would be needed for my current projects and future work.

## The Bucket List
	
Here's a few things that I imagine would be included in my ideal persistence solution…

- My API server defines the resources for my client application(s) to consume
- My client application(s) understand & treat resources as first class, having no need to transform the resource to yet another representation
- Wait, no transformation? Yeah, unless I want to, I do not want to be forced to.
- Only define my ORM concerns in one place on the server, not two (again on the client)
- I expect that less code means less bugs (I've seen a lot of bugs in data persistence layers)
- A thin codebase with nomenclature that is shared with the API format for a resource and it's operations
- During introspection of the representation of a resource within the client app, the object should have the same structure and nomenclature that the server defines for the resource
- My client app(s) should define the caching concerns for the requests resource(s) and have the option to honor the cache headers; 304's are fine. HTTP has solved caching already
- Optionally minimize redundant requests when making a query for a group of related resources
- Perhaps the caching strategy can be a mixin that works together with the resources which have properties to indicate when they are expired
- I want a service object that is injected wherever I interact with the resources, and a singleton for each service that has an event bus to communicate with all the resource instances of the same type. For example to make updates as close to real time as possible by PATCHing the resource
- I want to define the resource's states, some common states will work like `isDirty`
- I want the resource to know when it has changed and send that event to the service
- I need a simple way to compute properties from the resource attributes to meet the needs of the client application
- I want relationships between resources to be defined in a simple way and for the resources to know how to operate on its relations, like adding/removing relations as independent actions, totally separate from persisting the attributes of the resource itself
- I'd like a store service that is a facade to all the services that are used by the various resources, one point of service to call methods for fetching, crud operations, as well as operations on the resource's relation(s)
- I'd like each service to house it's own cache for it's type (entity) as well as track any meta data associated with the collection or per request
- The resources should keep track of their own meta data, relationships and links. The service(s) should not need to construct URLs for all the operations on a resource
- Oh, and I want URLs to be first class, The API server sends the links that the client should use
- Perhaps I can abandon XHR and go with [window.fetch](http://davidwalsh.name/fetch)

## Back to the Present

Now let's fast forward to today… Meet [JSON API](http://jsonapi.org), version 1.0 - A new specification. “Your anti-bikeshedding weapon.” Wow, two years of hammering out a specification for representing objects in JSON over HTTP (REST). The spec looks solid, I've taken it for a test drive over the last year - kicking the tires and testing out the spec as it has taken shape. I'm very impressed and happy with this specification. I imagine that it should last for some time, perhaps years to come. Maybe I'll bring my current projects up to the spec and later build out new application servers using a different language but use the same JSON API specification. Sounds promising, doesn't it!

But wait, aren’t you supposed to use  Ember Data? My suggestion is that you don’t let someone decide for you. Seek a solution that fits the problem domain of your project needs. That might be Ember Data, for me it is not; at lease not at 1.x or 2.x. Maybe the 3rd time will be the charm. What I'm interested in is a simple solution that is written from the ground up to fit the [format of the JSON API 1.0 Specification](http://jsonapi.org/format/), period. So, I can just get straight to work… shipping user stories (doing less bug hunting in the data library).

I've convinced myself to build a persistence solution, even though there is one that has existed for a couple years and has had about 300 contributors, including myself. And even though that solution has hit a (stable) release tag of v1.13, while also tagged for 2.0-beta on the same day. Seriously I'm not bitter or anything, [Ember Data](https://github.com/emberjs/data) is an excellent library. But what I've come to realize is that Ember Data does not provide the solution I am looking for. Ember Data provides a great adapter/serializer pattern to connect any type of data service to your Ember app. Ember Data thinks like an active record ORM; at least in nomenclature; `belongsTo` and `hasMany` remind me that Ember Data <u>needs</u> foreign keys as a primary way to connect relationships vs. URLs. I'm a web guy, I like URLs. URLs are the main selling point and reason I adopted Ember.js in the first place. The [Ember.Router](http://guides.emberjs.com/v1.12.0/routing/) has great URL support from the start.


## A Battle Plan Emerges

So here’s my plan… Do <u>only</u> what the server's specification defines for it's resources, and do <u>only</u> that. To simplify the mental model  for the client(s) that collaborate with the resources via server app(s). To fire the middleman, reduce the abstractions, reduce barriers for developers to ramp up on a project, minimize the code base which is responsible for the data layer. To build a direct path from point A to point B (client/server). I will use a solution that is direct and concise, with a strong set of features, proven solutions, and reserve the freedom add in my needs for caching and acting on state/events that make sense to the application's needs.

Actually this is not that hard, [Ember.js] has great primitives for some very advanced behaviors, like the [Ember.PromiseProxyMixin], [Ember.Evented], [Ember.Service] and [Ember.Object] prototypes. It would be hard if I did not have a few years of experience with the framework. With that experience I find a lot of power in using the Ember.js framework. [Dependency injection] is easy, the concept of services are first class, the testing story is excellent now, the [application.container] is my friend I can create factories for my resources and [register] singletons for my services.

[Ember.Object]: http://guides.emberjs.com/v1.12.0/object-model/classes-and-instances/
[Ember.Evented]: http://emberjs.com/api/classes/Ember.Evented.html
[Ember.PromiseProxyMixin]: http://emberjs.com/api/classes/Ember.PromiseProxyMixin.html
[Ember.Service]: http://emberjs.com/api/classes/Ember.Service.html
[Dependency injection]: http://guides.emberjs.com/v1.12.0/understanding-ember/dependency-injection-and-service-lookup/
[application.container]: http://emberjs.com/api/classes/Ember.Application.html#property_container
[register]: http://emberjs.com/api/classes/Ember.Application.html#method_register

So now I am taking the posture of a Samurai Warrior –  “dying before going into battle.” The warrior enters combat event without fear of death,  acceptance of his own death in advance. I tell myself, “Don't become like water my friend, instead become a dead man walking”.   I will unconditionally commit to success in battle  without worrying about survival. What I am about to describe is my tactical response to adopting the new JSON API specification, from the ground up. Yes, going forward, I will roll my own data persistence library – because I can and it's no longer hard to do. If the project dies so be it.


## A Man Can Change His Destiny

“The perfect blossom is a rare thing. You could spend your life looking for one, and it would not be a wasted life.” –Katsumoto (The Last Samurai)

Well I don't believe there is a perfect data persistence solution and won't suggest that I can create a perfect solution either. But, I will pursue it.


## The Nitty Gritty

Let's just assume that I could create an elegant solution. How would I do that using Ember.js?

First I'd get intimate with the [JSON API format](http://jsonapi.org/format/) Then I'd create a [Resource Object] as my base model prototype in an Ember app. I will begin by building an [Ember CLI addon] for the `Resource` and whatever else I need.

[Resource Object]: http://jsonapi.org/format/#document-resource-objects
[Ember CLI addon]: http://www.ember-cli.com/#developing-addons-and-blueprints

### A Resource Object

A Resource (or 'model') can resemble the structure of an object as defined by the JSON API 1.0 Specification. The `Resource` prototype creates hashes for: `attributes`, `relationships`, `links`, `meta`, and has attributes: `id` and `type`. The properties and structure of a model created by extending `Resource` closely follow the objects defined by the JSON API specification.

It would be used like so:

    export default Resource.extend({
      type: 'post',
      service: Ember.inject.service('posts'),

      title: attr(),
      date: attr(),
      excerpt: attr(),
      body: attr(),
      slug: attr(),

      author: hasOne('author'),
      comments: hasMany('comments')
    });

I want helpers to `get` and `set` the `attributes`, I'll use an `attr()` helper method to set that up. That method can track changes as properties are set and manage the current/previous attributes so I can know whether the instance has changed attributes. And by injecting a service I can emit events like `attributeChanged` so the service can persist the change in as close to real time as possible.

The Ember CLI addon can define `generators` so I can scaffold the prototypes for my resources, like the above example. I can just use `ember generate resource entityName`

The resource can have `addRelationship` and `removeRelationship` methods to compose the relationships that the resource is associated with. The `hasOne` and `hasMany` helpers can setup the computed properties that utilize the [Ember.PromiseProxyMixin] to find the related resource(s) based on the URLs in the resource's [relationships] object which contains [links] object(s)

[relationships]: http://jsonapi.org/format/#document-resource-object-relationships
[links]: http://jsonapi.org/format/#document-links

The resource can have an `isCacheExpired` property so that if the service keeps a reference or `cache` of it, the 'staleness' of the data can be found out.

And using the `attributes` hash of the `resource` instance I can compute properties from it for using in my templates that are read-only like so:

    export default Resource.extend({
      type: 'comment',
      service: Ember.inject.service('comments'),

      body: attr(),

      date: Ember.computed('attributes', {
        get() {
          return this.get('attributes.created-at');
        }
      }).readOnly(),

      commenter: hasOne('commenter'),
      post: hasOne('post')
    });

A new resource may be generated in a route model hook like so:

    model() {
      return this.container.lookup('model:posts').create({
        isNew: true,
        attributes: { date: new Date() }
      });
    }

Notice that the `attributes` hash is used to set initial properties. The computed properties created with the `attr()` helper are used as accessors to get/set rather than to create. That's how the resource was represented in JSON from the server anyway, resource attributes belong to the `attributes` object, I'll just keep it like that for the sake of simplicity.

Now that I have a base model or `Resource` with helpers to compose the properties that are meant to be used in the user interface (given to the template) I can setup an `Adapter` to fetch resources from a API server.


### An Adapter Object

This should be a singleton instance for each type of entity (or resource) that can be fetched and/or persisted.

Given that an Ember.js app may be hosted as a stand-alone client application and may choose to use use a proxy to bring an API server into it's own domain. It's likely that I may need a couple hooks manipulate the URL's in the `relationships` object of a resource - since it's required in a browser to work within the same domain. Unless you really want to use CORs (cross-origin resource sharing).

Imagine I have a `ApplicationAdapter` that is already setup to work with my JSON API server, I could use something like this:

    import ApplicationAdapter from './application';
    import config from '../config/environment';

    export default ApplicationAdapter.extend({
      type: 'post',

      url: config.APP.API_PATH + '/posts',

      fetchUrl: function(url) {
        const proxy = config.APP.API_HOST_PROXY;
        const host = config.APP.API_HOST;
        if (proxy && host) {
          url = url.replace(proxy, host);
        }
        return url;
      }
    });

Well I need to define at least one URL for the service, from there I can use the relationships' links' objects.

Perhaps the methods my `Adapter` needs are: `find`, `findOne`, `findQuery`, `findRelated`, `fetch`, `createResource`, `deleteResource`, `updateResource`, `patchRelationship`, and `cacheResource`. And a couple properties: `type` and `url`. That should make for solid interface to speak JSON over HTTP.

Now that I have an `Adapter` I'll need a `Serializer` object to serialize/deserialize resources, basically I need to make `Resource` instances after I `fetch` and will need to serialize changed attributes to patch the resource to meet my goal of persisting changes as close to real time as possible.


### A Serializer Object


Well I think since I've followed a solid specification, JSON API, the needs for this prototype will be simple.

Perhaps the interface will include methods to: `deserialize`, `deserializeIncluded`, `deserializeResource`, `deserializeResources`, `serialize`, `serializeChanged`, `serializeResource`.

I may use a private method for how the resources are created perhaps like:

    /**
      Create a Resource from a JSON API Resource Object
      See <http://jsonapi.org/format/#document-resource-objects>
      @private
      @method _createResourceInstance
      @param {Object} json
      @return {Resource} instance
    */
    _createResourceInstance(json) {
      const factoryName = 'model:' + json.type;
      json.meta = json.meta || {};
      return this.container.lookupFactory(factoryName).create({
        'type': json.type,
        'id': json.id,
        'attributes': json.attributes,
        'relationships': json.relationships,
        'links': json.links,
        'meta': json.meta
      });
    }

Like I said earlier the `Resource` should closely resemble the specification. No need to change it around and confuse things for developers. 

Well this may be different that what people are used to, but the JSON API spec is sweet - so going with that. Notice that the properties created with the `attr()` helper are not used during `.create()` all the attributes belong in the `attributes` object, period; that sould be protected, that's how the spec defines attributes.

Using an initializer, I can register this factory in the application container and inject a singleton instance as dependency into the `Adapter` singleton. Oh, did I mention that I'd register and inject the `Adapter` factory? Yeah these two work in tandem.

Please be patient my friend, I'll get to all the details about initialization soon. I think I'm still missing a couple pieces, like a strategy for caching.


### A Cache Mixin

Well now this is a can of worms. I thought HTTP and browsers already solved this problem. Yes, and now is my opportunity to get out of the business of managing a distributed cache by blindly pushing everything into memory and dancing around that.

Managing a distributed cache requires flexibility. When a client application receives a representation of a `resource` from a server, the client should be able to expire that cached object (in the browser application) based on the server's response headers; or by whatever means the developer chooses.

Perhaps the caching plan for a service is simply creating a `ServiceCacheMixin` that can be easily customized and has some basic defaults. I recall that Akamai defaults to about 7 minutes, or at least when I used it that was our default. How about that, I'll setup a property for the `Resource` prototype with an expires time e.g. `cacheDuration` and a computed boolean for `isCacheExpired`.

The cache mixin will need a property to hold it's contents, e.g. `cache` and some methods like: `cacheControl`, `cacheData`, `cacheLookup`, `cacheMeta`, `cacheResource`, `cacheUpdate`. 

The `cacheControl` method can track the response headers from the request and mark some timestamps like the server time and the client time, for our simple expire in X minutes approach.

Why would I want to cache the data in memory anyway? I mentioned that was a solved problem, no?

I want to fetch a resource that `hasMany` other resources and in my template will reference that like `resource.comments` so that the related resources are fetched (asynchronously and on demand). Those related resources may have a common relation, let's call it a *commenter*. For example a *post* has a bunch of *comments*, cause you know it was popular. An there was some dialog so a few people commented a fews times in the discussion. Well I don't want to fetch those same *commenters* over and over do I? I don't mind the option to cache, but also like the option not to. To cache or not to cache that is a question for the server and perhaps the developer. That's where the default expires time comes in handy. As the developer I can set the rules for how long a resource is temporarily cached in memory and when I just want to trust the cache headers and lean on 304 responses.

If the caching strategy is simply a mixin it's a great hook to do something more advanced like using the `cacheData`, `cacheMeta` and `cacheLookup` to keep offline copies in localStorage if I want to be 'offline ready'.

Hum, so now that I have an adapter, a serializer and a cache mixin it seems like that would be a good recipe for a `Service` object to manage the combined solution for data persistence. Perhaps so…


### A Service Object

A service for a resource can work to persist an instance of that entity using crud operations with HTTP verbs: CREATE, PATCH, GET, DELETE. The service can be named after the nouns of my JSON API server. For example a post resource (entity) may be requested using GET `/api/v1/posts` or GET `/api/v1/posts/1`. A `service` instance can be a singleton that is registered on my application's container using a pluralized name for the entity, e.g. 'posts'. Again we'll need to use an initializer to put this service into play and may also inject the service at will, for example on the resource prototypes using `Ember.inject.service('posts')` 

Perhaps `Service` objects are "evented" to facilitate close to real-time updates.

When an `attr` is `set` and the value has changed the resource may emit an event for `attributeChanged` on the resource's `service` object.  The adapter can listen to this event and respond with a call to `updateResource` which in turn sends a PATCH request with only the data for the changed attributes (a payload created by the serializer's `serializeChanged` method).

That would be a good way for the collaboraters, the fantastic four (adapter, serializer, cache and resources), to form as a `service` to act out the requirements for the application's data persistence needs.

A `PostsService` object may be as simple as this:

    import Adapter from '../adapters/post';
    import ServiceCache from '../mixins/service-cache';

    Adapter.reopenClass({ isServiceFactory: true });

    export default Adapter.extend(ServiceCache);

With the injection of this service into the `Resource` instances there is an event bus for these collaborators to work.

Now that these four prototypes have taken shape let's get into the business of dependency injection using an initializer.


### The Resource Blueprint

Since I am building an Ember CLI addon for this data persistence solution I can create [blueprints] for all the things.

[blueprints]: http://www.ember-cli.com/#developing-addons-and-blueprints

The `resource` blueprint is a generator for an initializer, a resource, an adapter, a serializer, and a service - all created by using the command `ember generate resource post`

So here is what the initializer can look like to set all these objects into motion:

    import Service from '../services/posts';
    import Model from '../models/post';
    import Adapter from '../adapters/post';
    import Serializer from '../serializers/post';

    export function initialize(container, application) {
      const adapter = 'service:posts-adapter';
      const serializer = 'service:posts-serializer';
      const service = 'service:posts';
      const model = 'model:posts';

      application.register(model, Model, { instantiate: false });
      application.register(service, Service);
      application.register(adapter, Adapter);
      application.register(serializer, Serializer);

      application.inject(model, 'service', service);
      application.inject('service:store', 'posts', service);
      application.inject(service, 'serializer', serializer);
    }

    export default {
      name: 'posts-service',
      after: 'store',
      initialize: initialize
    };

Did you notice that, this initializer executes after the `store` initializer, but I did not create a store yet. Oops, I sould do that. Developers like having a `store`. 

“Let’s put a smile on that face!” -Heath Ledger’s Joker (The Dark Knight)


### The Store Service Object

A `store` service can be injected into the routes. This is similar to how [Ember Data] uses a `store`, but the `resource` should be referenced in the plural form (like my API endpoint), easy peasy.

[Ember Data]: https://github.com/emberjs/data

The interface for a `store` service can be a simple facade for the services created for each `resource` in the application. I can call the `store` method and pass in the `resource` name, e.g. 'post' which interacts with the 'posts' service for my 'post' `resource`.

An example `route` hook to find all post resources from the `posts` service:

    import Ember from 'ember';

    export default Ember.Route.extend({
      model() {
        return this.store.find('post');
      }
    });

This `Store` object is a facade to the various other `Service` objects in the application. Each service will be injected into the to store service. So it can be a service of services. One interface for all my persistance needs.

In the example above, the store object can pluralize the type, to lookup the resource's service object, i.e. 'service:posts'.

Wait, isn't that how Ember's Route#model hook works anyway? Yeah basically, `this.store.find('post', '1')` or I can use a query object: `this.store.find('post', {sort: 'desc', filter: 'blah'})`;

I'm not sure if you think this solution would be a lot of work or not. I would work toward create a solid test suite as well. Perhaps that can be a follow up post - *on testing a data persistence solution.*  Now that Ember CLI makes unit testing simple and easy to embrace testing should be fairly straight forward to achieve. Well in addition to the tests there is a dummy application that can be built as demo; even utilized for my manual testing needs - like using a proxy to a live JSON API server. That's what I would do, test all the things, both automated unit tests and manual using an app.

**(Spoiler alert)** This app is running with a JSON API server and this data persistence solution – so here is your demo and proof of concept.


## Take Aways

I recommend getting to know the JSON API 1.0 Spec. I propose that your data persistence solution can be a direct line between your client and server while still utilizing a robust feature set which is inline to accompany the way your application server defines and operates on resources.

Whether you adopt the JSON API 1.0 spec or not… this example (addon) can be a template for creating a data persistence solution for your Ember.js application – which models the domain of your API server without any extra abstraction.

One of the primary drivers for keeping my data layer thin is this concept **e = mc<sup>2</sup>**, that is **Errors = (More Code)<sup>2</sup>**. I'd like less code and only code that fits my use cases.

#### Start Today

I hope you caught on, in this post I used a verb tense as if I will need to build out this solution. But actually, I already have. Here is a review on [emberobserver.com](http://emberobserver.com/addons/ember-jsonapi-resources)

- [The README](https://github.com/pixelhandler/ember-jsonapi-resources/blob/master/README.md)
- [Demo App](https://github.com/pixelhandler/jr-test) (this blog is also a demo of using the solutions linked below)
- [Developer's Guide](https://github.com/pixelhandler/ember-jsonapi-resources/wiki)
- [Code Documentation](http://pixelhandler.github.io/ember-jsonapi-resources/docs/)
- [Travis builds](https://travis-ci.org/pixelhandler/ember-jsonapi-resources/builds)

#### JSON API Implementations

- [JSON API implementations](http://jsonapi.org/implementations/)
- Ember CLI Addon - [Ember JSONAPI Resources](https://github.com/pixelhandler/ember-jsonapi-resources)
- Ruby gem - [JSONAPI::Resources](https://github.com/cerebris/jsonapi-resources)

[Ember.js]: http://emberjs.com
