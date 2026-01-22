---
title: 'Ember.js: Handling Failure Using Route `error` Substates'
slug: emberjs-handling-failure-using-route-error-substates
published_at: '2016-01-19'
author: pixelhandler
tags:
- Ember.js
- Ember Addons
- Data
- JSON API
meta_description: |-
  Handing data persistence operations between your Ember (client) application and
  API server requires fault tolerance. The app needs to notify users of relevan...
---

## Practical Example…

At the top level, where all `error` events bubble to, is the `ApplicationRoute`.
An `application_error` substate can be added using a combination of both an
`application-error` route and `application-error` template. If you only display
the `error.message` and have no need to use a condition to set a title on the
template, then you could use the template alone (without an error route substate).

The application error template below handles any error thrown by a route that is
not handled by a child route's `error` substate.

The **app/router.js** file will not need any error routes added, they are built-in.

Since the `model` is passed to the `setupController(controller, error)` hook,
the `error.message` property can be rendered to notify the user of the error.

**app/templates/application-error.hbs**

    <h1>Oops, the app is borked…</h1>
    <p>{{model.message}}</p>

Alternatively, when a substate is not used to display an error notification,
your application template can display any messages that you set on the
application controller; e.g. `errorMessage` and `errorDetails`.

**app/templates/application.hbs**

    {{#if errorMessage}}
      <button class="error-message" {{action 'dismissErrorMessage'}}>
        {{errorMessage}} {{errorDetails}}
      </button>
    {{/if}}
    
    {{outlet}}

If you want to vary the error notification text of the error substate template,
use the `setupController` hook to set a `title` property for the template.

In a route (below the application), e.g. the `PostRoute`, an error substate can
be used to branch the display of the title to differentiate between a **client**
and **server** error like so:

**app/templates/post-error.hbs**

    <h1>{{title}}</h1>
    <p>{{model.message}}</p>

The `title` attribute of the controller is used in the above template. It is
customized depending on the error code.

**app/routes/post-error.js**

    import Ember from 'ember';
    
    export default Ember.Route.extend({
      setupController(controller, error) {
        let title = 'Oops, this post is borked…';
        let code = error.code || error.get('code');
        if (code) {
          if (code >= 500) {
            title = 'Oops, there was a server error…';
          } else if (code === 404) {
            title = "Opps, can't find this one…";
          }
          controller.set('title', title);
        }
        this._super(controller, error);
      }
    });

Since the application template may be used for errors that you do not need to
transition to an `error` substate, the user will need a way to dismiss. An
action `dismissErrorMessage` can be used to clear application error properties.

**app/routes/application.js**

    import Ember from 'ember';
    
    export default Ember.Route.extend({
      errorMessage: null,
      errorDetails: null,
    
      actions: {
        dismissErrorMessage() {
          this.controllerFor('application').setProperties({
            'errorMessage': null,
            'errorDetails': null
          });
        }
      }
    });

The `application_error` substate will be used to display any [500] errors, or
a [404] error. However, in the case of a specific client error like [400] or [422]
that your application should handle without making a transition, conditions will
need to be added to branch the behavior between using `error` substates and the
application `error` template.

If you use any nested routes, for example **admin/edit** and **admin/create**,
you can define specific error substates at that level in the route structure,
(below the application's default error handing).

**app/templates/admin/edit-error.hbs**

    <h1>{{title}}</h1>
    <p>{{model.message}}</p>

Notice the template above is the same as the 'post-error.hbs' template. The post
`error` template handles the display of non-admin errors; the "/admin/" directory
is used for editing and creating resources.

The route hierarchy used in this example is below. When using the `error` substates
you do not need to add any routes to the *router.js* file. Error substates are
built into the [Ember.js] Router.

**app/router.js**

    import Ember from 'ember';
    import config from './config/environment';
    
    const Router = Ember.Router.extend({
      location: config.locationType
    });
    
    Router.map(function() {
      this.route('index', { path: '/' });
      this.route('post', { path: '/:post_id' }, function () {
        this.route('detail', { path: '/' });
        this.route('comments');
      });
      this.route('admin', function () {
        this.route('index');
        this.route('create');
        this.route('edit', { path: ':edit_id' });
      });
    });
    
    export default Router;

To assit with testing the `error` substates - I set the `PostController` of the
backend (API) to respond with an error. This is the repo for the API application:
[blog-api] using a branch 'ember-jsonapi-resources-testing'. See the commented
code I used to send [error responses].

I used the `setupController` hook to set a relevant `title` for the notification
and used a console *warning* for a condition that should not be handled by a
transition. In an effort to build a solution for the desired user experience,
it can be helpful to log the error conditions.

**app/routes/admin/edit-error.js**

    import Ember from 'ember';
    
    export default Ember.Route.extend({
      setupController(controller, error) {
        let title = 'Oops, this post is borked…';
        let code = error.code || error.get('code');
        if (code) {
          if (code >= 500) {
            title = 'Oops, there was a server error…';
          } else if (code === 404) {
            title = "Opps, can't find this one…";
          } else if (code === 422) {
            Ember.Logger.warn('Not expecting to handle 422 in an error substate');
          }
          controller.set('title', title);
        }
        this._super(controller, error);
      }
    });

The post form component sends an `update` action to persist changes via the Post
resource endpoint.

**app/templates/admin/edit.hbs**

    <p><strong>Edit a Blog Post</strong></p>
    {{form-post post=model isNew=model.isNew on-edit=(action "update")}}

The action is triggered after the user exists the field, this prevents a flood
of updates from every keystroke - caused from binding a model property to an input.

**app/components/form-post.js**

    import Ember from 'ember';
    import BufferedProxy from 'ember-buffered-proxy/proxy';
    
    export default Ember.Component.extend({
      tagName: 'form',
    
      resource: Ember.computed('post', function() {
        return BufferedProxy.create({ content: this.get('post') });
      }).readOnly(),
    
      isNew: null,
      isEditing: true,
    
      focusOut() {
        if (!this.get('isNew')) {
          this.get('resource').applyChanges();
          this.set('isEditing', false);
          let action = this.get('on-edit');
          if (typeof action === 'function') {
            action(this.get('post'), function callback() {
              this.set('isEditing', true);
            }.bind(this));
          }
        }
      }
      /* … */
    });

The `admin.edit` route responds to the actions send by the form component. After
the API request is made successfully, the `callback` function, sent with the action,
is called. Or, an error may be caught by the failed promise.

In the case of an error, the changes to the model are rolled back and the error
response is handled by the route. It depends on the error code whether or not
a transition will be made to an `error` substate. When an error is not thrown by
a route's model hook, then a transition needs to be made explicitly via `catch`.

In the example below, it may be a bad user experience to transition away from the
admin form the user is editing - due to a client error (such as "Bad Request" [400],
or an "Unprocessable Entity" [422]). Instead, error properties are set on the
application controller which results in a dismissible error notification.

**app/routes/admin/edit.js**

    import Ember from 'ember';
    import ApplicationErrorsMixin from 'jr-test/mixins/application-errors';
    
    export default Ember.Route.extend(ApplicationErrorsMixin, {
      model(params) {
        return this.store.find('posts', params.edit_id);
      },
    
      setupController(controller, model) {
        this._super(controller, model);
        controller.set('isEditing', true);
      },
    
      actions: {
        update(model, callback) {
          return this.store.updateResource('posts', model)
          .finally(function() {
            if (typeof callback === 'function') {
              callback();
            }
          })
          .catch(function(error) {
            model.rollback();
            this.send('error', error);
          }.bind(this));
        },
    
        error(error) {
          if (error.code === 422 || error.code === 400) {
            this.handleApplicationError(error);
          } else {
            this.intermediateTransitionTo('admin.edit_error', error);
          }
        }
      }
    });

So that both the *admin/edit* and *admin/create* routes can use the same behavior,
the method `handleApplicationError` is defined in a mixin.

This mixin is used to parse the error responses and format error details.

**app/mixins/application-errors.js**

    import Ember from 'ember';
    
    export default Ember.Mixin.create({
    
      handleApplicationError(error) {
        let details = this.handleUnprocessableEntities(error);
        details = details || this.handleBadRequest(error);
        this.controllerFor('application').setProperties({
          'errorMessage': error.message,
          'errorDetails': details || undefined
        });
      },
    
      handleBadRequest(error) {
        if (error.code !== 400 || !error.errors.length) { return; }
        // See https://github.com/cerebris/jsonapi-resources#error-codes
        let errors = error.errors.filterBy('code', 105);
        errors = errors.mapBy('detail');
        return (!errors) ? '' : errors.join(' ');
      },
    
      handleUnprocessableEntities(error) {
        if (error.code !== 422 || !error.errors.length) { return; }
        // See https://github.com/cerebris/jsonapi-resources#error-codes
        let errors = error.errors.filterBy('code', 100);
        let fields = errors.map(function(error) {
          let paths = error.source.pointer.split('/');
          let attr = paths[paths.length - 1].split('_');
          attr = attr.map(function(str) {
            return Ember.String.capitalize(str);
          });
          return attr.join(' ');
        });
        return (!fields) ? '' : 'Invalid fields: ' + fields.join(', ') + '.';
      }
    });

For the *admin/create* route no `error` substate template was needed. For handling
[500] errors the parent application `error` substate will be used. And, for
handling [400] or [422] responses it makes sense to display the errors "in-context",
without making a transition to a substate. The only reason the `admin.edit_error`
substate uses the `admin/edit/error.hbs` template is to handle a [404] and a [500]
response. That is not the case with the `admin.create` route; the parent substate,
`application_error` will work just fine.

Notice the naming convention used with ember-cli, the substates use a `.` period
and `_` for the substate name and the templates use `/` and `-`. So, to transition
to the application error substate use `application_error` like so:
`this.intermediateTransitionTo('application_error', err)`, or to a nested substate:
`this.intermediateTransitionTo('admin.edit_error', err)`.

## Take-Aways…

The `ApplicationRoute` `error` action handler can be used to catch and handle
various errors and delegate the notification of the errors to the
`ApplicationController` and accompanying HTMLBars application template. Or, an
`applicaton_error` substate with an `applicaton-error` template may handle
route `error` events.

Also, you may combine both `error` substates and `error` action handling strategies
in a creative way my sending the `error` event when the error occurs as the result
of another action; instead of by a model hook method, e.g. `model`, `beforeModel`,
`afterModel`, etc.

I favor the using `error` substates as the primary strategy for fault tolerance
in an ember application. I also like the fact that the `error` action may be
utilized creatively as a secondary strategy.

In the [Ember JSONAPI Resources] addon a [ErrorMixin] defines error types for:

* `ServerError` - handles 50x
* `ClientError` - handles 40x
* `FetchError` (default failure) - handles 30x

The error objects thrown by a resource's `service` includes the error code.
You can use the `code` to determine how to present the error notification, use
the error type, or use the `error.name` property. The `error.code` the most specific.

Based on the `error.code` the route `error` action can transition to a custom route
to handle that specific error type. In the first example, a transition is made to
a `/not-found` route, that could have used an `intermediateTransitionTo` to keep
the URL unchanged.

However, there is a catch when using a route's `error` action, by doing so the route
`error` substates are not used. The second solution does not use use the
route `error` action. Instead, it uses route `error` substates with `error` templates.

Using the `error` substates allows the use of the `route-name_error` state and
associated `route-name-error` template. The `setupController` hook of the `*_error`
route receives objects: `controller` and `error` (as it's `model`). Using the route
`error` substate to define properties for the error template is a good way to
customize the display of the error notifications, depending on the error code.

When the error is not thrown by one of the route model hooks, perhaps by a custom
`action`, you can decide how to handle the error. If the error is recoverable
perhaps set properties on the application controller for display by the application
template. Or, if the error is not recoverable perhaps fire the `error` event on
the route, e.g. `this.send('error', resp);`

(One caveat - the current state of using an acceptance test for an error substate
is that the test may fail. Any error may cause your test adapter to fail the test.
See [12791].)

The [ember-jsonapi-resources] addon uses custom error objects to make fault tolerance
first class in your ember application.

### Further Reading…

- [Ember.js Loading and Error Substates](https://guides.emberjs.com/v2.2.0/routing/loading-and-error-substates/#toc_code-error-code-substates)
- [JSON API Error Objects](http://jsonapi.org/examples/#error-objects-error-codes)
- [JSONAPI::Resources Error Codes](https://github.com/cerebris/jsonapi-resources#error-codes)
- [Rails Layouts and Rendering](http://guides.rubyonrails.org/layouts_and_rendering.html)
- [Ember.js Acceptance Testing Issue](https://github.com/emberjs/ember.js/issues/12791#issuecomment-170675020)
- [Ember.js Debugging](https://guides.emberjs.com/v2.2.0/configuring-ember/debugging/)

[ErrorMixin]: https://github.com/pixelhandler/ember-jsonapi-resources/blob/master/addon/utils/errors.js
[jr-test]: https://github.com/pixelhandler/jr-test
[jr-test route.js]: https://github.com/pixelhandler/jr-test/blob/master/app/router.js
[blog-api]: https://github.com/pixelhandler/blog-api/tree/ember-jsonapi-resources-testing
[error responses]: https://github.com/pixelhandler/blog-api/blob/ember-jsonapi-resources-testing/app/controllers/api/v1/posts_controller.rb#L4-L14
[500]: http://httpstatus.es/500
[422]: http://httpstatus.es/422
[404]: http://httpstatus.es/404
[400]: http://httpstatus.es/400
[Ember.js]: http://emberjs.com
[ember-jsonapi-resources]: http://ember-jsonapi-resources.com
[Ember JSONAPI Resources]: https://github.com/pixelhandler/ember-jsonapi-resources
[Error Handling Guide]: https://github.com/pixelhandler/ember-jsonapi-resources/wiki/Error%20Handling
[12791]: https://github.com/emberjs/ember.js/issues/12791