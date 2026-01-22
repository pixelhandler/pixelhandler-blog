---
title: How to Use 404 Page in Your Ember.js Application
slug: how-to-use-404-page-in-your-emberjs-application
published_at: '2014-08-29'
author: pixelhandler
tags:
- Ember.js
meta_description: Every so often someone in the `#emberjs` irc channel asks, "How
  do I handle a 404 page using Ember.js?" For example, see this [stackoverflow question],
  "How ...
---

## Cases when a 404 page is needed

1. When the URL does not match any defined routes, the application should render a 404 page.
1. When a route's `model` hook has a call to `this.store` or `Em.$.ajax` and the result is a promise that is rejected perhaps the application should show a 404 page. 

For example, when your adapter cannot find the resource that a route is expected to fetch. Ember.js routes may use an `error` action to transition to a 404 page. This will support a route which fails to transition due to a rejected promise caused by one or more of the route's hooks, e.g. `model`. 

## Catch-all route

To address the first case (above), when a given url doesn't match any route, define the last route in your router using a [wildcard globbing route]. 

[wildcard globbing route]: http://emberjs.com/guides/routing/defining-your-routes/#toc_wildcard-globbing-routes

I setup a route for **[not-found]** in my router. The last route uses the wildcard `/*path` to catch any text string not already matched by other routes or resources. See the `'not-found'` route in the router example below.

[not-found]: https://github.com/pixelhandler/blog/blob/master/client/app/router.js

    Router.map(function () {
      this.route('about');
      this.resource('posts', function () {
        this.resource('post', { path: ':post_slug' });
      });
      this.route('not-found', { path: '/*path' });
    });

When the wildcard path matches a url that should result in the application rendering a 404 page, the (404) [not-found route] utilizes the `redirect` hook in order to transition to the url `/not-found`. My app has a Route prototype (app/routes/not-found.js) which is mapped to the 'non-found' route:

[not-found route]: https://github.com/pixelhandler/blog/blob/master/client/app/routes/not-found.js

    import Ember from 'ember';

    export default Ember.Route.extend({
      redirect: function () {
        var url = this.router.location.formatURL('/not-found');
        if (window.location.pathname !== url) {
          this.transitionTo('/not-found');
        }
      }
    });

The result is that the application renders a `not-found` template (templates/not-found.hbs) with a link to my archives page. 

[not-found template]: https://github.com/pixelhandler/blog/blob/master/client/app/templates/not-found.hbs

    <h1>404 Not Found</h1>
    <p>
      Perhaps you have a link that has changed, see {{#link-to 'posts'}}Archives{{/link-to}}.
    </p>

## Error in a route hook

Any route having a hook (e.g. `model`, `beforeModel`, `afterModel`) that results in a rejected promise, can use the `error` action to transition to the 404. See the [Ember.Route error event] doc page.

[Ember.Route error event]: http://emberjs.com/api/classes/Ember.Route.html#event_error

Define the action, log the error and transition to the '/not-found' page

    import Ember from 'ember';

    export default Ember.Route.extend({
      actions: {
        error: function (error) {
          Ember.Logger.error(error);
          this.transitionTo('/not-found');
        }
      }
    });

Here is my 404 page: <http://pixelhandler.com/not-found>.