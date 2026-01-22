---
title: Developing a Modular JavaScript Application With RequireJS and Backbone.js
slug: developing-a-modular-javascript-application-with-requirejs-and-backbonejs
published_at: '2012-02-03'
author: pixelhandler
tags:
- Backbone.js
meta_description: "Currently I am developing a JavaScript application using open source\nframeworks
  and libraries. Included the mix are… \n[jQuery Mobile](http://jquerymobile.com..."
---

## A few reasons I enjoy the JavaScript development community

I find it refreshing that many of these libraries have a fair amount of
adoption within the development community. One of the primary objectives on
this project is to build the application with modular code. Also to load
modules when the specific components are needed for execution rather than the
entire library which becomes the finish application. The AMD specification and
the compatibility with RequireJS and other libraries is very attractive.
RequireJS gives me the ability to author various modules and manage the code
dependencies efficiently. Also with the build and optimization features of
RequireJS I am able to organize the modules within packages. I broke down the
file organization by having common directories for models, views, collections
(objects defined using Backbone) and a few other directories, like syncs,
utils to extend the functionality of Backbone. The modules in each directory
are built into a single common package of modules and the package can be
required by other modules which reside in other packages (groups of code for
specific feature/component implementation, e.g. site chrome). I forked an open
source book [Backbone.js Fundamentals](https://github.com/pixelhandler/backbone-fundamentals) on these topics adding an explanation on how I am
building and optimizing using packages of modules; see the section "Optimize
and Build a Backbone JavaScript application with Require.JS using Packages". I
posted this section on the [HauteLookTech.com blog](http://www.hautelooktech.com/2012/02/01/optimize-and-build-a-backbone-js-javascript-application-with-require-js-using-packages/) as well.

After spending a few weeks during code freeze at work and trying out all these
libraries we began development for a mobile application. In an effort to
rapidly prototype the web application I began to build with [jQuery Mobile](http://jquerymobile.com/demos/1.0.1/docs/about/getting-started.html).
This gave our team common components that work across a wide range of devices
without overloading us with testing. Also the theme roller for jQuery Mobile
is a handy tool for the building a base skin for the mobile site. With only a
few sketches and by generating a mobile theme that looked very _blueprint-ish_
we began authoring a site prototype to work out the features and components
that should be included in the mobile site application. Since the site
framework is built with Backbone we will not use the jQuery Mobile routing
features; however for the prototype this mobile framework was very handy right
out of the box. Recently there have been many talks and articles on the
concept of **"mobile first"**, basically the small screen helps to define what
really matters and helps to put usability as a high priority. This ends up
striking a nice balance between identifying requirements for design, usability
and the application's functionality. Using the logic-less template library,
Mustache to render JSON from the web service layer is much funner than all
kinds of crazy DOM fragment manipulation to render data. I found a great
tutorial post on using [HTML Templates with Mustache.js](http://coenraets.org/blog/2011/12/tutorial-html-templates-with-mustache-js/).

I am developing the framework based on Backbone.js which has the dependency of
the Underscore.js library - a very robust set of tools that complement
Backbone, especially with filtering collections. Also, Backbone needs either
jQuery or Zepto, I am content with jQuery. The Deferred and Callbacks objects
in the current version of jQuery also help to manage asynchronous behaviors of
the components within the framework. For example, I can add a Deferred object
to a collection and within a view object only render after the resolution of
the deferred property of the required collection object. The Callbacks object
comes in handy using a view object that programmatically renders partial
templates based on various child views, I can iterate over options passed to a
view and define child views based on the options, then add to the (parent)
view object's render method callbacks to render the child views. Though
Backbone does not provide (out of the box) a collection view; there are good
solutions posted online. So, when I need to program some behavior that is not
included in Backbone, I often discover good solutions online that I can borrow
from. For me, the bottom line is that Backbone gives common patterns for
developing a data-driven application backed by a RESTful API and is very
extendable. Backbone does not box me in, yet is fairly straight forward for me
to build on top of, also giving solid structure to the components I need in
developing a modular application.

About modular code, which JavaScript does not currently provide a standard,
there are plenty of patterns you can use. For me
[AMD](http://requirejs.org/docs/whyamd.html) is just fine. Even though a
future standard my be different than the way AMD operates, the API fits well
into current libraries. One thing I notice is that when there is a need for
some functionality in JavaScript many solutions pop up in the community; which
is great. However, it would be nice if developers find a good solution and
adopt it; it would seem that more adoption and development using the ‘good’
solution would lead to the said solution becoming _even better_ or _great_ and
the use of the solution would become easier for other developers to adopt and
implement. AMD is a good solution for [modules using RequireJS](http://requirejs.org/docs/why.html), some would argue _‘the’_
solution. For now, it is a viable solution and I’m using it. The Group for AMD
JS Module API has forks for AMD compatible versions of
[Backbone.js](https://github.com/amdjs/backbone) and
[Underscore.js](https://github.com/amdjs/underscore) libraries.

Perhaps the most enjoyment I find in JavaScript development with this mix of
libraries is the discovery of a solution based on using [behavior-driven development (BDD)](http://dannorth.net/introducing-bdd/) methodologies; and of
course discovering though this _lather, rinse, repeat_ (test-driven
development) practice. The combination of
[Jasmine](http://pivotal.github.com/jasmine/), [jQuery-Jasmin](https://github.com/velesin/jasmine-jquery) and
[Sinon.JS](http://sinonjs.org/) testing libraries is powerful to say the
least. I really enjoy getting from red to green, in passing the tests. I find
that sometimes the hardest part is to guess what exactly will prove the
solution yet to be discovered. This development approach helps to break down a
solution by proving the expected behavior with simpler units of behavior which
can be tested and verified independently from the application itself. Sinon.JS
provides an nice and [fake XHR server](http://sinonjs.org/docs/#server) for
[testing Backbone.js applications](http://tinnedfruit.com/2011/03/03/testing-backbone-apps-with-jasmine-sinon.html). Jasmine has
[spies](https://github.com/pivotal/jasmine/wiki/Spies) which replace a
function that it is spying on, and Jasmine-jQuery adds the sweetness of
fixtures, jQuery based matchers and event spies to complete a solid suite for
a front-end developer to embrace the process of test-driven development. It is
very nice to execute the tests on various mobile devices during development to
ensure cross platform/device compatibility.

Node.js came in very handy in authoring a shell script to prep and build using
the [r.js optimizer](http://requirejs.org/docs/optimization.html). I needed to
have a site that can be hosted in a cloud environment with out any server-side
script execution. So adding to the RequireJS optimizer script I added a
release script to modify my build.js and index.html files to utilize a
specified build directory. And, node is just cool, right?

I would like tell an anecdote from my youth to summarize the experience I have
using this combination of JavaScript libraries and frameworks. When I was a
kid I loved wearing Docs (Dr. Martens). These are warehouse style boots with
air-cushioned soles (dubbed **Bouncing Soles**). A kid I knew wrote a song, "I
can climb mountains, I can climb rocks, I can do anything when I wear my
Docs." These bouncing soles give a sense of invincibility to a young man full
of spit and well you know. I feel the same way when developing with Backbone,
Underscore, Node.js, AMD, Jasmine, jQuery and RequireJS. Perhaps I should
write a song, "I can pass my specs, I can mock my requests, I can build
anything with Backbone, Underscore, jQuery and RequireJS". On second thought,
I'll spare you the pain of my lack of musical talent. to wrap it up happy
developer build awesome stuff, and these group of libraries and the community
behind them makes me a kick-xxx happy developer, seriously.
