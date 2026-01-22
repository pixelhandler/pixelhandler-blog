---
title: Real-time Data for an Ember.js Application using WebSockets
slug: real-time-data-in-an-emberjs-application-with-websockets
published_at: '2014-08-20'
author: pixelhandler
tags:
- Ember.js
- Data
- WebSocket
meta_description: "**UPDATE 6/28/15:** This post is not up-to-date with the current
  release of Ember Orbit. Inspired from my experience using Ember Orbit I ended up
  writing the..."
---

Following the release of Orbit.js, [Ember Orbit] was announced at the [Wicked Good Ember] conference. Again, I became excited about using smaller JSON Patch payloads (media type "application/json-patch+json"), see [RFC 6902]. I started a new branch and decided to support a REST source first; then later tackle a WebSocket source. I am a fan of the [JSON API] specification which does include [patch support]. Once I had a JSONAPISource working with Ember Orbit on my branch I updated my SocketSource prototype (class) to follow the JSONAPISource prototype so they could share the same serializer. Also if the client's browser doesn't support a WebSocket or perhaps in the case my socket server gets wacky the application can initialize with the JSONAPISource instead of the SocketSource prototype as the connected source to the application's MemorySource.
[Dan Gebhardt]: https://twitter.com/dgeb
[Ember.js]: http://emberjs.com/
[Ember Orbit]: https://github.com/orbitjs/ember-orbit
[Orbit.js]: https://github.com/orbitjs/orbit.js
[blog repository]: https://github.com/pixelhandler/blog
[Ember SC talk]: https://gist.github.com/pixelhandler/5389c72c82d26fae8fb1
[Wicked Good Ember]: http://wickedgoodember.com/dan-gebhardt
[RFC 6455]: http://tools.ietf.org/html/rfc6455
[JSON API]: http://jsonapi.org/
[patch support]: http://jsonapi.org/format/#patch

## A Few Reasons to use WebSockets

**Push support** in a browser application can be used to provide real-time updates site visitors. Waiting for a client's next request or page refresh to provide updates works great when you expect frequent reloads. However, when an application is shipped as a single page (an Ember.js application) push support is attractive.

* Web Sockets (TCP)
  * Potentially closer to real-time interations compared to REST
  * Ships with All modern (popular) browsers, see [caniuse.com/#search=Socket][caniuse-Socket]
  * Gets around CORS

* Smaller payloads (partial representation of a resource)
  * [JSONPatch][RFC 6902], [jsonpatch.com]

* Connecting multiple storage adapters
  * Memory <-> localStorage <-> Web Socket (remote db)

* High availability (in a distributed computing system)
  * Weak consistency with higher availability
  * Choose liveness (eventually there) over Safety (always right)

[caniuse-Socket]: http://caniuse.com/#search=Socket
[RFC 6902]: https://tools.ietf.org/html/rfc6902
[jsonpatch.com]: http://jsonpatch.com
[RFC 6455]: http://tools.ietf.org/html/rfc6455

## JSON Patch

See: [jsonpatch.com] ...


### Simple example

The original document:

    {
      "baz": "qux",
      "foo": "bar"
    }

The patch:

    [
      { "op": "replace", "path": "/baz", "value": "boo" },
      { "op": "add", "path": "/hello, "value": ["world"] },
      { "op": "remove, "path": "/foo}
    ]

The result:

    {
       "baz": "boo",
       "hello": ["world"]
    }

### Operations

*Add, Remove, Replace, Copy, Copy, Test*

#### Add

    {"op": "add", "path": "/biscuits/1", "value": {"name": "Ginger Nut"}}

Adds a value to an object or inserts it into an array. In the case of an array the value is inserted before the given index. The - character can be used instead of an index to insert at the end of an array.

#### Remove

    {"op": "remove", "path": "/biscuits"}

Removes a value from an object or array.

#### Replace

    {"op": "replace", "path": "/biscuits/0/name", "value": "Chocolate Digestive"}

Replaces a value, equivalent to a “remove” followed by an “add”.


### JSON Patch payloads used by this blog app

An add operation...


    {"op":"add","path":"/posts/-","value":{"id":"a4d213d6-5595-4686-9817-169a7eddbda1","slug":"test","title":"test title","date":"2014-10-29","excerpt":"test excerpt text","body":"test body text","links":{"author":null}}}

    {"path":"/posts/a4d213d6-5595-4686-9817-169a7eddbda1/links/author","op":"add","value":"5c9b62ec-1569-448b-912a-97e6d62f493e"}

    {"path":"/authors/5c9b62ec-1569-448b-912a-97e6d62f493e/links/posts/-","op":"add","value":"a4d213d6-5595-4686-9817-169a7eddbda1"}

A delete operation...


    {"op":"remove","path":"/posts/341207e0-cfd9-4d3a-a5ab-d2268ab2e472/links/author"}

    {"op":"remove","path":"/authors/5c9b62ec-1569-448b-912a-97e6d62f493e/links/posts/341207e0-cfd9-4d3a-a5ab-d2268ab2e472"}

    {"op":"remove","path":"/posts/341207e0-cfd9-4d3a-a5ab-d2268ab2e472"}

_Compare with the JSON API payloads_

* http://pixelhandler.com/api/posts?limit=1
* http://pixelhandler.com/api/authors?limit=1


## [Orbit.js]

Let's take a look at the [ember-orbit-example] [demo app](http://localhost:9000).

[orbitjs/orbit.js]: https://github.com/orbitjs/orbit.js
[ember-orbit-example]: https://github.com/dgeb/ember-orbit-example

Watch Dan give an intoduction to Orbit.js. (YouTube video from the Jan '14 Boston Ember Meetup)

* [Introduction to Orbit.js by Dan Gebhardt](https://www.youtube.com/watch?v=IAwk_mF-dWo)
* [introducing Orbit.js slides](https://speakerdeck.com/dgeb/introducing-orbit-dot-js)

### How Orbit works

* Orbit requires that every data source support one or more common interfaces. These interfaces define how data can be both accessed and transformed.
* The methods for accessing and transforming data return promises.
* Multiple data sources can be involved in a single action

**Orbit.js uses JSON / JSONPatch by default.**

* Sends partial data
* Uses multiple stores

### Orbit interfaces:

1. Requestable
   * for managing requests for data via methods such as `find`, `create`, `update` and `destroy`
1. Transformable
   * Keep data sources in sync through low level transformations (using JSON PATCH spec)
   * `transform` is the method your data source (prototype) object needs to implement

#### Requestable

Events associated with an action:

* `assistFind`, `rescueFind`, `didFind`, `didNotFind`

#### Transformable

A single method, `transform`, which can be used to change the contents of a source.

    {op: 'add', path: 'planet/1', value: {__id: 1, name: 'Jupiter', classification: 'gas giant'}
    {op: 'replace', path: 'planet/1/name', value: 'Earth'}
    {op: 'remove', path: 'planet/1'}

### TransformConnector

A TransformConnector watches a transformable source and propagates any transforms to a transformable target.

Each connector is "one way", so bi-directional synchronization between sources requires the creation of two connectors.


### RequestConnector

A RequestConnector observes requests made to a primary source and allows a secondary source to either "assist" or "rescue" those requests.

The mode of a RequestConnector can be either "rescue" or "assist" ("rescue" is the default).

### Document

Document is a complete implementation of the JSON PATCH spec detailed in RFC 6902.

It can be manipulated via a transform method that accepts an operation, or with methods `add`, `remove`, `replace`, `move`, `copy` and `test`.

Data at a particular path can be retrieved from a `Document` with `retrieve()`.

## [Ember Orbit]

"A library that integrates Orbit.js with Ember.js to provide flexibility and control in your application's data layer" 

* Video: [Building Autonomous Web Applications with Ember and Orbit]

[Building Autonomous Web Applications with Ember and Orbit]: https://www.youtube.com/watch?v=omc4pnXv1Ds

This project uses [ember-cli], to the modules below use ES6 syntax, see the [ES6 draft].

[ember-cli]: http://www.ember-cli.com/
[ES6 draft]: https://people.mozilla.org/~jorendorff/es6-draft.html

### Initializer

Configure Ember-Orbit with an application initializer that sets up Orbit and registers a "main" store and schema to be available in routes and controllers.

[initializers/ember-orbit.js]


    import Orbit from 'orbit';
    import EO from 'ember-orbit';
    import JSONAPISource from 'orbit-common/jsonapi-source';
    import ApplicationSerializer from '../serializers/application';
    import SocketSource from '../adapters/socket-source';
    import Ember from 'ember';
    import config from '../config/environment';

    Orbit.Promise = Orbit.Promise || Ember.RSVP.Promise;

    function jsonApiStore() {
      Orbit.ajax = Ember.$.ajax;
      return EO.Store.extend({
        orbitSourceClass: JSONAPISource,
        orbitSourceOptions: {
          host: config.APP.API_HOST,
          namespace: config.APP.API_PATH,
          SerializerClass: ApplicationSerializer,
          usePatch: true,
        }
      });
    }

    function socketStore() {
      return EO.Store.extend({
        orbitSourceClass: SocketSource,
        orbitSourceOptions: {
          host: config.APP.SOCKET_URL,
          SerializerClass: ApplicationSerializer,
          usePatch: true,
        }
      });
    }

    var Schema = EO.Schema.extend({
      idField: 'id',

      init: function (options) {
        this._super(options);
        this._schema.meta = Ember.Map.create();
      }
    });

    export default {
      name: 'ember-orbit',
      after: 'socket',

      initialize: function(container, application) {
        application.register('schema:main', Schema);
        application.register('store:main', EO.Store);
        if (notPrerenderService() && canUseSocket(container)) {
          application.register('store:secondary', socketStore());
        } else {
          application.register('store:secondary', jsonApiStore());
        }
        connectSources(container);

        application.inject('controller', 'store', 'store:main');
        application.inject('route', 'store', 'store:main');
      }
    };

    function notPrerenderService() {
      return window.navigator.userAgent.match(/Prerender/) === null;
    }

    function canUseSocket(container) {
      return window.WebSocket && container.lookup('socket:main');
    }

    function connectSources(container) {
      var primarySource = container.lookup('store:main').orbitSource;
      var secondarySource = container.lookup('store:secondary').orbitSource;
      // Connect (using default blocking strategy)
      setupConnectors(primarySource, secondarySource);
    }

    function setupConnectors(primary, secondary/*, local*/) {
      new Orbit.TransformConnector(primary, secondary);
      new Orbit.TransformConnector(secondary, primary);
      primary.on('assistFind', secondary.find);
    }

[initializers/ember-orbit.js]: https://github.com/pixelhandler/blog/blob/master/client/app/initializers/ember-orbit.js

### Sources

"Source are very thin wrappers over Orbit sources"

[adapters/socket-source.js]


    import Ember from 'ember';
    import Orbit from 'orbit';
    import OC from 'orbit-common';
    import SocketService from '../services/socket';
    import JSONAPISource from 'orbit-common/jsonapi-source';

    Orbit.Promise = Orbit.Promise || Ember.RSVP.Promise;

    var SocketSource = JSONAPISource.extend({

      init: function (schema, options) {
        Orbit.assert('SocketSource requires SocketService be defined', SocketService);
        Orbit.assert('SocketSource requires Orbit.Promise be defined', Orbit.Promise);
        Orbit.assert('SocketSource only supports usePatch option', this.usePatch);
        this._socket = SocketService.create();
        this.initSerializer(schema, options);
        // not calling super, instead calling template/abstract prototype init method
        return OC.Source.prototype.init.apply(this, arguments);
      },

      initSerializer: function (schema, options) {
        // See JSONAPISource
        this.SerializerClass = options.SerializerClass || this.SerializerClass;
        if (this.SerializerClass && this.SerializerClass.wrappedFunction) {
          this.SerializerClass = this.SerializerClass.wrappedFunction;
        }
        this.serializer = new this.SerializerClass(schema);
      },

      // using JSONPatch via WebSocket
      usePatch: true,

      // Requestable interface implementation

      _find: function(type, id) {
        if (id && (typeof id === 'number' || typeof id === 'string')) {
          return this._findOne(type, id);
        } else {
          return this._findQuery(type, id);
        }
      },

      _findLink: function() {
        console.error('TODO, SocketSource#_findLink not supported yet');
      },

      // Requestable Internals

      _findOne: function (type, id) {
        var query = this._queryFactory(type, { id: id });

        return this._remoteFind('find', type, query);
      },

      _findMany: function () {
        throw new Error('SocketSource#_findMany not supported');
      },

      _findQuery: function (type, query) {
        query = this._queryFactory(type, query);

        return this._remoteFind('findQuery', type, query);
      },

      _remoteFind: function (channel, type, query) {
        var root = pluralize(type);
        var id = query.id;
        query = JSON.stringify(query);

        // handle promise resolution serially, pass off return to next then handler
        var records;
        return new Orbit.Promise(function doFind(resolve, reject) {
          this._socket.emit(channel, query, function didFind(raw) {
            if (raw.errors || !raw[root]) {
              reject(raw.errors);
            } else {
              resolve(raw);
            }
          });
        }.bind(this))
        .then(function doProcess(raw) {
          return this.deserialize(type, id, raw);
        }.bind(this))
        .then(function (data) {
          records = data;
          return this.settleTransforms();
        }.bind(this))
        .then(function () {
          // finally send back the records
          return records;
        })
        .catch(function onError(error) {
          console.error('SocketSource#_remoteFind Error w/ query: ' + query);
          console.error(error);
        });
      },

      _queryFactory: function (type, query) {
        query = query || {};
        query.resource = query.resource || pluralize(type);

        var attrs = Ember.String.w('limit offset sortBy order resource withFields');
        attrs.forEach(function (attr) {
          query[attr] = query[attr] || Ember.get(this, attr);
        }.bind(this));

        return query;
      },

      // Transformable Internals

      _transformAdd: function (operation) {
        var type = operation.path[0];
        var id = operation.path[1];
        var remoteOp = {
          op: 'add',
          path: '/' + pluralize(type) + '/-',
          value: this.serializer.serializeRecord(type, operation.value)
        };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformReplace: function (operation) {
        var type = operation.path[0];
        operation.path[0] = pluralize(type);
        var id = operation.path[1];
        var remoteOp = {
          op: 'replace',
          path: '/' + operation.path.join('/'),
          value: this.serializer.serializeRecord(type, operation.value)
        };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformRemove: function (operation) {
        var type = operation.path[0];
        operation.path[0] = pluralize(type);
        var id = operation.path[1];
        var path = '/' + operation.path.join('/');
        var remoteOp = { op: 'remove', path: path };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformUpdateAttribute: function (operation) {
        var type = operation.path[0];
        operation.path[0] = pluralize(type);
        var id = operation.path[1];
        var remoteOp = {
          op: 'replace',
          path: '/' + operation.path.join('/'), // includes attr in path
          value: operation.value
        };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformAddLink: function (operation) {
        var type = operation.path[0];
        operation.path[0] = pluralize(type);
        var id = operation.path[1];
        var link = operation.path[3];
        var linkId = operation.path[4] || operation.value;
        var linkDef = this.schema.models[type].links[link];
        var path;
        if (linkDef.type === 'hasMany') {
          operation.path.pop();
          path = '/' + operation.path.join('/').replace(/__rel/, 'links') + '/-';
        } else if (linkDef.type === 'hasOne') {
          path = '/' + operation.path.join('/').replace(/__rel/, 'links');
        }
        var remoteOp = { path: path, op: 'add', value: linkId };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformRemoveLink: function (operation) {
        var type = operation.path[0];
        operation.path[0] = pluralize(type);
        var id = operation.path[1];
        var path = '/' + operation.path.join('/').replace(/__rel/, 'links');
        var remoteOp = { op: 'remove', path: path };
        return this._remotePatch(type, id, remoteOp);
      },

      _transformReplaceLink: function (operation) {
        console.error('TODO, SocketSource#_transformReplaceLink not supported yet');
      },

      _remotePatch: function (type, id, remoteOp) {
        var records;
        // handle promise resolution serially, pass off return to next then handler
        return new Orbit.Promise(function doPatch(resolve, reject) {
          this._socket.emit('patch', JSON.stringify(remoteOp), function didPatch(raw) {
            if (raw && raw.errors) {
              reject(raw.errors);
            } else {
              resolve(raw); // doesn't matter what raw is, socket called back w/o errors
            }
          });
        }.bind(this))
        .then(function doProcess(raw) {
          if (raw && Array.isArray(raw)) {
            return this.deserialize(type, id, raw[0]);
          }
          return null;
        }.bind(this))
        .then(function (data) {
          records = data;
          return this.settleTransforms();
        }.bind(this))
        .then(function () {
          // finally send back the records
          return records;
        })
        .catch(function onError(error) {
          console.error(error);
          var e = "SocketSource#_remotePatch Error w/ op: %@, path: %@";
          throw new Error(e.fmt(remoteOp.op, remoteOp.path));
        });
      }

    });

    // TODO use Ember.Inflector https://github.com/stefanpenner/ember-inflector.git
    var pluralize = function (name) {
      return name + 's';
    };
    // borrowed from 'orbit/lib/objects'
    var isObject = function(obj) {
      return obj !== null && typeof obj === 'object';
    };

    export default SocketSource;

[adapters/socket-source.js]: https://github.com/pixelhandler/blog/blob/master/client/app/adapters/socket-source.js


### Stores

"Stores extend sources and are also repositories for models. All of the data in a store is maintained in its internal source."

Below are a few examples of how I use the application store in a Route:

Custom query for posts


    model: function () {
      var query = { offset: this.get('offset'), limit: this.get('limit') };
      return this.store.find('post', query);
    },

List of posts


    model: function () {
      return this.store.find('post');
    },

A specific post by id


    model: function (params) {
      return this.store.find('post', params.edit_id);
    },

A post route that can find a post from the store's memory or ask the secondary source (adapter) for the resource


    model: function (params) {
      return new Ember.RSVP.Promise(function (resolve, reject) {
        var found = this.store.filter('post', function (post) {
          return post.get('slug') === params.post_slug;
        });
        if (found.get('length') > 0) {
          resolve(found[0]);
        } else {
          this.store.find('post', params.post_slug).then(
            function (post) {
              resolve(post);
            },
            function (error) {
              reject(error);
            }
          );
        }
      }.bind(this));
    },

#### Push Support

Routes can use a mixin for push support for real-time update to connected clients.

[mixins/push-support.js]


    import Ember from 'ember';

    export default Ember.Mixin.create({

      beforeModel: function () {
        this.socketSanityCheck();
        return this._super();
      },

      socketSanityCheck: function () {
        // Sanity check, is socket working? check output browser console.
        var socket = this.socket;
        socket.on('hello', function (data) {
          console.log(data);
          socket.emit('talk-to-me', 'I like talking.', function (msg) {
            console.log('back talk', msg);
          });
        });
      },

      // Template methods...

      onDidPatch: Ember.required,

      patchRecord: function (operation) {
        this._patchRecord(operation);
      },

      addLink: Ember.K,
      replaceLink: Ember.K,
      removeLink: Ember.K,
      addRecord: Ember.K,
      updateAttribute: Ember.K,
      deleteRecord: Ember.K,

      // Use in template methods...

      _patchRecord: function (operation) {
        operation = (typeof operation === 'string') ? JSON.parse(operation) : operation;
        if (!operation.op || !operation.path) {
          console.error('Push error! Invalid patch operation.');
          return;
        }
        if (operation.path.match('/links/') !== null) {
          if (operation.op === 'add') {
            Ember.run.later(this, 'addLink', operation, this._delay);
          } else if (operation.op === 'replace') {
            Ember.run.next(this, 'replaceLink', operation);
          } else if (operation.op === 'remove') {
            Ember.run.next(this, 'removeLink', operation);
          }
        } else {
          if (operation.op === 'add') {
            Ember.run.next(this, 'addRecord', operation);
          } else if (operation.op === 'replace') {
            Ember.run.next(this, 'updateAttribute', operation);
          } else if (operation.op === 'remove') {
            Ember.run.next(this, 'deleteRecord', operation);
          }
        }
      },

      _addLink: function(operation) {
        var model = this._retrieveModel(operation);
        if (model) {
          var type = operation.path.split('/links/')[1];
          var relation = this.store.retrieve(type, { primaryId: operation.value });
          if (relation) {
            model.addLink(type, relation);
          }
        }
      },

      _replaceLink: function(operation) {
        console.error('TODO replaceLink not supported yet', operation);
      },

      _removeLink: function(operation) {
        var model = this._retrieveModel(operation);
        if (model) {
          var path = operation.path.split('/links/')[1].split('/');
          var type = path[0];
          var id = path[1];
          var relation = null;
          if (id) {
            relation = this.store.retrieve(type, { primaryId: id });
          }
          model.removeLink(type, relation);
        }
      },

      _addRecord: function (operation) {
        var type = this._extractType(operation);
        var id = operation.value.id;
        var model = this.store.retrieve(type, { primaryId: id });
        if (!model) {
          this.store.add(type, operation.value);
          this.store.then(function() {
            model = this.store.retrieve(type, { primaryId: id });
            var name = this.get('routeName');
            var collection = this.modelFor(name);
            if (collection && !collection.contains(model)) {
              collection.insertAt(0, model);
              this.controllerFor(name).set('model', collection);
            }
          }.bind(this));
        }
      },

      _updateAttribute: function(operation) {
        var type = this._extractType(operation);
        if (!type) {
          return;
        }
        var typeKey = this.store.schema._schema.pluralize(type);
        var path = operation.path.split('/' + typeKey + '/')[1];
        var id, attribute;
        if (path.indexOf('/') !== -1) {
          path = path.split('/');
          id = path[0];
          attribute = path[1];
        }
        var model = this.store.retrieve(type, {primaryId: id});
        if (model && attribute) {
          model.set(attribute, operation.value);
        }
      },

      _deleteRecord: function (operation) {
        var model = this._retrieveModel(operation);
        if (model) {
          var name = this.get('routeName');
          var collection = this.modelFor(name);
          if (collection) {
            collection.removeObject(model);
          }
          var controller = this.controllerFor(name);
          if (controller) {
            controller.removeObject(model);
          }
          if (model.constructor.typeKey) {
            var type = model.constructor.typeKey;
            var id = model.get('primaryId');
            Ember.run.later(this.store, 'remove', type, id, this._delay);
          }
        }
      },

      _extractType: function (operation) {
        var path = operation.path.split('/');
        var type = this.store.schema._schema.singularize(path[1]);
        if (!this.store.schema._schema.models[type]) {
          console.error('Cannot extract type', path);
        }
        return type;
      },

      _retrieveModel: function (operation) {
        var path = operation.path.split('/');
        var type = this.store.schema._schema.singularize(path[1]);
        var id = path[2];
        return this.store.retrieve(type, { primaryId: id });
      },

      _delay: 1000

    });

[mixins/push-support.js]: https://github.com/pixelhandler/blog/blob/master/client/app/mixins/push-support.js


### Routes using the push support mixin

[routes/application.js]


    import Ember from 'ember';
    import PushSupport from '../mixins/push-support';
    import config from '../config/environment';

    var ApplicationRoute = Ember.Route.extend(PushSupport, {

      model: function () {
        return this.store.find('post');
      },

      /* some code not included here */

      // Push support...

      onDidPatch: function () {
        this.socket.on('didPatch', this.patchRecord.bind(this));
      }.on('init'),

      addLink: function (operation) {
        this._addLink(operation);
      },

      removeLink: function (operation) {
        this._removeLink(operation);
      },

      addRecord: function (operation) {
        this._addRecord(operation);
      },

      updateAttribute: function (operation) {
        this._updateAttribute(operation);
      },

      deleteRecord: function (operation) {
        this._deleteRecord(operation);
      },

      /* some code not included here */

    });

    function lookupSocket(container) {
      if (!window.WebSocket) {
        return false;
      }
      return container.lookup('socket:main');
    }

    /* some code not included here */

    export default ApplicationRoute;

[routes/application.js]: https://github.com/pixelhandler/blog/blob/master/client/app/routes/application.js


[routes/index.js]


    import Ember from 'ember';
    import RecordChunksMixin from '../mixins/record-chunks';
    import ResetScroll from '../mixins/reset-scroll';
    import PushSupport from '../mixins/push-support';

    export default Ember.Route.extend(ResetScroll, RecordChunksMixin, PushSupport, {

      /* some code not included here */

      model: function () {
        var posts = this.modelFor('application');
        if (this.get('offset') < posts.get('length')) {
          return posts;
        } else {
          var query = this.buildQuery();
          return this.store.find('post', query);
        }
      },

      // Push support...

      onDidPatch: function () {
        this.socket.on('didPatch', this.patchRecord.bind(this));
      }.on('init'),

      addRecord: function (operation) {
        if (operation.path.split('/')[1] === 'posts') {
          var posts = this.model();
          var controller = this.controllerFor(this.get('routeName'));
          if (typeof posts.then === 'function') {
            posts.then(function (_posts) {
              controller.set('model', _posts);
            });
          } else {
            controller.set('model', posts);
          }
        }
      },

      deleteRecord: function (operation) {
        if (operation.path.split('/')[1] === 'posts') {
          this._deleteRecord(operation);
        }
      }

      /* some code not included here */

    });

[routes/index.js]: https://github.com/pixelhandler/blog/blob/master/client/app/routes/index.js



## [Socket.IO]

The push support is provided by an adapter on the server which uses [Socket.IO] and interacts directly with a document storage database.

[server/lib/socket_adapter.js]


    /**
      @module app
      @submodule socket_adapter

      db adapter using Socket.io
    **/

    var db = require('./rethinkdb_adapter');
    var debug = require('debug')('socket_adapter');
    var config = require('../config')();

    /**
      Exports setup function

      @param {Object} express server
      @return {Object} `io` socket.io instance
    **/
    module.exports = function(server, sessionMiddleware) {

      // options: https://github.com/Automattic/engine.io#methods-1
      var options = {
        'transports': ['websocket', 'polling'],
        'cookie': 'connect.sid'
      };

      var io = require('socket.io')(server, options);

      io.use(function(socket, next) {
        sessionMiddleware(socket.request, socket.request.res, next);
      });

      io.on('connection', function (socket) {
        // Simple sanity check for client to confirm socket is working
        socket.emit('hello', { hello: 'world' });
        socket.on('talk-to-me', function (data, cb) {
          cb(data);
        });

        socket.on('isLoggedIn', function (callback) {
          var user = socket.request.session.user;
          if (!!user) { debug('isLogggedIn', user); }
          callback(!!user);
        });

        socket.on('login', function (credentials, callback) {
          credentials = JSON.parse(credentials);
          if (!credentials) {
            return callback(false);
          }
          var uname = credentials.username;
          var pword = credentials.password;
          var session = socket.request.session;
          if (uname === config.admin.username && pword === config.admin.password) {
            session.user = uname;
            debug('login: %s', session.user);
            session.save();
            callback(true);
          }
        });

        socket.on('logout', function (callback) {
          socket.request.session = null;
          callback(true);
        });

        socket.on('findQuery', findQuery);

        socket.on('find', find);

        socket.on('patch', function (operation, callback) {
          if (!socket.request.session.user) {
            debug('patch tried without user session');
            return callback(JSON.stringify({errors: ["Login Required"]}));
          }
          var _callback = function (error, payload) {
            if (error) {
              debug('Patch Error!', error);
              callback({errors: error});
            } else {
              payload = payload || JSON.stringify({code: 204});
              callback(payload);
              debug('didPatch...', operation, payload);
              socket.broadcast.emit('didPatch', operation);
            }
          };
          patch(operation, _callback);
        });

        socket.on('disconnect', function () {
          io.emit('error', 'User disconnected');
        });
      });

      return io;
    };

    /**
      findQuery - uses query to find resources

      @param {String} JSON strigified query object `resource` property is required
      @param {Function} callback
      @private
    **/
    function findQuery(query, callback) {
      debug('findQuery...', query);
      if (typeof query === 'string') {
        query = JSON.parse(query);
      }
      var resource = query.resource;
      delete query.resource;
      var _cb = callback;
      db.findQuery(resource, query, function (err, payload) {
        if (err) {
          debug(err);
          payload = { errors: { code: 500, error: 'Server failure' } };
        }
        _cb(payload);
      });
    }

    /**
      find - uses query to find resources by id or slug

      @param {String} JSON strigified query object requires `resource`, `id` properties
      @param {Function} callback
      @private
    **/
    function find(query, callback) {
      debug('find...', query);
      if (typeof query === 'string') {
        query = JSON.parse(query);
      }
      var resource = query.resource;
      delete query.resource;
      var id = query.id;
      delete query.id;
      var _cb = callback;
      var errorPayload = { errors: { code: 500, error: 'Server failure' } };
      db.find(resource, id, function (err, payload) {
        if (err) {
          _cb(errorPayload);
        } else {
          if (payload[resource] !== null) {
            _cb(payload);
          } else {
            db.findBySlug(resource, id, function (err, payload) {
              if (err) {
                _cb(errorPayload);
              } else {
                if (payload[resource] !== null) {
                  _cb(payload);
                } else {
                  _cb({ errors: { code: 404, error: 'Not Found' } });
                }
              }
            });
          }
        }
      });
    }

    function patch(operation, callback) {
      debug('patch...', operation);
      if (typeof operation === 'string') {
        operation = JSON.parse(operation);
      }
      var path = operation.path.split('/');
      var type = path[1];
      var id = path[2];
      var prop = path[3]; // REVIEW support sub-path?
      if (prop === 'links') {
        var link = path[4];
        patchLinks(type, id, link, operation, callback);
      } else if (operation.op === 'replace') {
        var payload = {};
        payload[prop] = operation.value;
        db.updateRecord(type, id, payload, callback);
      } else if (operation.op === 'remove') {
        db.deleteRecord(type, id, callback);
      } if (operation.op === 'add') {
        db.createRecord(type, operation.value, callback);
      }
    }

    function patchLinks(type, id, linkName, operation, callback) {
      debug('patchLinks...', type, id, linkName, operation);
      find({resource: type, id: id}, function (record) {
        if (!record || record && record.errors) {
          var errors = (record) ? record.errors : [];
          debug('Error finding resource for patchLinks action', errors);
          callback(errors);
        } else {
          var path = operation.path.split(linkName);
          path = (path) ? path[1] : null;
          var value = operation.value;
          var op = operation.op;
          var payload = record[type];
          payload.links = payload.links || {};
          payload.links[linkName] = payload.links[linkName] || [];
          if (op === 'add' && path.match(/\-$/) !== null && value) {
            payload.links[linkName].push(value);
          } else if (value && op === 'add' || op === 'replace') {
            payload.links[linkName] = value;
          } else if (op === 'remove') {
            var linkId = path.split('/');
            if (linkId.length > 1) {
              linkId = linkId[1];
              var idx = payload.links[linkName].indexOf(linkId);
              payload.links[linkName].splice(idx, 1);
            } else {
              payload.links[linkName] = null;
            }
          }
          db.updateRecord(type, id, {links: payload.links}, callback);
        }
      });
    }

    // TODO Use Ember.Inflector or other Inflector?
    function singularize(name) {
      return name.slice(0, name.length - 1);
    }

    function pluralize(name) {
      return name + 's';
    }

[Socket.IO]: http://socket.io/
[server/lib/socket_adapter.js]: https://github.com/pixelhandler/blog/blob/master/server/lib/socket_adapter.js
