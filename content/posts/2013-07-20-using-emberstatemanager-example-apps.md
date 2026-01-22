---
title: 'Using Ember.StateManager: Example Apps'
slug: using-emberstatemanager-example-apps
published_at: '2013-07-20'
author: pixelhandler
tags:
- Ember.js
meta_description: |-
  **Example Apps**

  This article demonstates two examples of using [Ember#StateManager][0] to
  manage state that does not need to be represented by a URL.

  * Th...
---

## What is a Finite-State Machine?

Illustration from [Wikipedia][3] -


> It is conceived as an abstract machine that can be in one of a finite number of states. The machine is in only one state at a time; the state it is in at any given time is called the current state. It can change from one state to another when initiated by a triggering event or condition; this is called a transition. A particular FSM is defined by a list of its states, and the triggering condition for each transition. 

> An example of a very simple mechanism that can be modeled by a state machine is a turnstile. 

> A turnstile, used to control access to subways and amusement park rides, is a gate with three rotating arms at waist height, one across the entryway. Initially the arms are locked, barring the entry, preventing customers from passing through. Depositing a coin or token in a slot on the turnstile unlocks the arms, allowing them to rotate by one-third of a complete turn, allowing a single customer to push through. After the customer passes through, the arms are locked again until another coin is inserted.

> The turnstile has two states: **Locked** and **Unlocked**. There are two inputs that affect its state: putting a coin in the slot (*coin*) and pushing the arm (*push*). In the locked state, pushing on the arm has no effect; no matter how many times the input push is given it stays in the locked state. Putting a coin in, that is giving the machine a coin input, shifts the state from **Locked** to **Unlocked**. In the unlocked state, putting additional coins in has no effect; that is, giving additional coin inputs does not change the state. However, a customer pushing through the arms, giving a push input, shifts the state back to **Locked**.


## A Turnstile as an Ember application

### Demo

Example Turnstile application built with Ember see in working at [jsbin][4], source code at: [github][1]


### Templates

**templates/application**

    <script type="text/x-handlebars">
      {{outlet}}
    </script>

**templates/index**

    <script type="text/x-handlebars" data-template-name="index">
      <button {{ action 'coin' controller }}>Coin</button>
      <button {{ action 'push' controller }}>Push</button>
      <h3>{{ display }}</h3>
      <p>
        Turnstile is: {{ currentState }}<br/>
        Total Coins: {{ totalCoins }}
      </p>
    </script>    

### Application

**javascript/app.js**

    var App = Ember.Application.create({
      ready: function(){
        App.turnstileManager = App.TurnstileManager.create({
          enableLogging: true
        });
      }
    });
    
    App.IndexRoute = Ember.Route.extend({
      setupController: function( controller ){
        var manager = App.turnstileManager;
        manager.set( 'controller', controller );
        controller.send( 'state', manager.get( 'currentState.name' ) );
      },
    
      events: {
        coin: function( controller ){
          App.turnstileManager.send( 'coin', controller );
        },
    
        push: function( controller ){
          App.turnstileManager.send( 'push', controller );
        }
      }
    });
    
    App.IndexController = Ember.Controller.extend({
      totalCoins: 0,
    
      display: 'Please insert coin.',
    
      onCoin: function( display, isAccepted ){
        this.set( 'display', display );
        if( isAccepted ){
          this.incrementProperty( 'totalCoins' );
        }
      },
    
      onPush: function( display ){
        this.set( 'display', display );
      },
    
      onSetup: function( display ){
        this.set( 'display', display );
      },
    
      state: function( name ){
        this.set( 'currentState', name );
      }
    });
    
    App.BaseState = Ember.State.extend({
      unhandledEvent: function( manager, eventName ) {
        console.log( manager.toString() + ': unhandledEvent with name ' + eventName );
      },
    
      enter: function( /*manager*/ ){},
    
      setup: function( manager, context ){
        var controller = ( context ) ? context : manager.get('controller');
        if( controller ){
          controller.send( 'state', manager.get('currentState.name') );
          controller.send( 'onSetup', 'Please insert coin.' );
        }
      },
    
      exit: function( /*manager*/ ){}
    });
    
    App.TurnstileManager =  Ember.StateManager.extend({
      initialState: 'locked',
    
      locked: App.BaseState.extend({
        coin: function( manager, context ){
          context.send( 'onCoin', 'Payment accepted.', true );
          manager.transitionTo( 'unlocked', context );
        },
    
        push: function( manager, context ){
          context.send( 'onPush', 'Coin required, please insert coin.');
        }
      }),
    
      unlocked: App.BaseState.extend({
        setup: function( manager, context ){
          context.send( 'state', manager.get( 'currentState.name' ) );
          context.send( 'onSetup', 'Please proceed.');
        },
    
        coin: function( manager, context ){
          context.send( 'onCoin', 'No coin needed. Try pushing.', false );
        },
    
        push: function( manager, context ){
          manager.transitionTo( 'inUse', context );
        },
    
        inUse: App.BaseState.extend({
          setup: function( manager, context ){
            context.send( 'state', manager.get( 'currentState.name' ) );
            context.send( 'onSetup', 'Please wait.');
            Ember.run.later(function(){
              manager.transitionTo( 'locked', context );
            }, 1500);
          }
        })
      })
    });

## Slide Deck as an Ember application

This browser app was created for a tech talk at the <http://www.meetup.com/Ember-SC/> meetup group. We discussed [Ember.StateManager in July 2013](http://www.meetup.com/Ember-SC/events/125461412/)

The ember slide deck app can run in two modes, `idling` and `playing`. Slides that have a time value (`milliseconds` property) automatically enter the `playing state`. When the `next` action is triggered by the `keyPress` event for a slide with no `milliseconds` the app transitions back to `idling`. Every slide has a URL so app state is managed with Ember.Router but states for playing and idling depend on user's behavior and the states exist along side the state represented in the URLs.

In the sample `fixtures.js` file the slides in the two sections automatically play then stop before the next section.

### Templates

**templates/application**

    <script type="text/x-handlebars">
      {{outlet}}
    </script>

**templates/slide-deck/slide.html**

    <script type="text/x-handlebars" id="slide">
      <img {{bindAttr src="model.filename"}}>
      <input type="text" value="">
    </script>    

**templates/slide-deck/slides.html**

    <script type="text/x-handlebars" id="slides">
      {{#each model}}
        {{#linkTo 'slide' this}}
          <img {{bindAttr src="filename"}}>
        {{/linkTo}}
      {{/each}}
    </script>


### Application

**javascript/slide-deck/app.js**

    // Application
    App = Ember.Application.create({
      ready: function(){
        App.stateMachine = App.StateMachine.create({
          //enableLogging: true
        });
      }
    });
    
    // Model
    App.Store = DS.Store.extend({
      revision: 12,
      adapter: 'DS.FixtureAdapter'
    });
    
    App.Slide = DS.Model.extend({
      filename: DS.attr('string'),
      milliseconds: DS.attr('number')
    });
    
    // States
    App.StateMachine = Ember.StateManager.extend({
      initialState: 'idling',
      idling: Ember.State.extend({
        next: function (manager, context) {
          var milliseconds = context.get('currentModel.milliseconds');
          if (milliseconds && milliseconds !== 0) {
            manager.transitionTo('playing', context);
          } else {
            var id = '' + (+context.get('currentModel.id') + 1);
            window.document.location = '#/slides/' + id;
          }
        }
      }),
      playing: Ember.State.extend({
        setup: function (manager, context) {
          this.next(manager, context);
        },
        next: function (manager, context) {
          var id = '' + (+context.get('currentModel.id') + 1);
          window.document.location = '#/slides/' + id;
          this.play(manager, context);
        },
        play: function (manager, context) {
          var milliseconds = context.get('currentModel.milliseconds');
          if (milliseconds && milliseconds !== 0) {
            this.startInterval(context, milliseconds);
          } else {
            this.stopInterval();
            manager.transitionTo('idling', context);
          }
        },
        startInterval: function (context, milliseconds) {
          var id = '' + (+context.get('currentModel.id') + 1);
          this.timeoutId = Ember.run.later(function(){
            window.document.location = '#/slides/' + id;
            App.stateMachine.send('play', context);
          }, milliseconds);
        },
        stopInterval: function () {
          if (this._timeoutId) {
            Ember.run.cancel(this._timeoutId);
            delete this._timeoutId;
          }
        }
      })
    });
    
    App.Router.map(function() {
      this.resource('/');
      this.resource('slides');
      this.resource('slide', { path: '/slides/:slide_id' });
    });
    
    App.IndexRoute = Ember.Route.extend({
      redirect: function() {
        this.transitionTo('slides');
      }
    });
    
    App.SlidesRoute = Ember.Route.extend({
      model: function() {
        return App.Slide.find();
      }
    });
    
    App.SlideRoute = Ember.Route.extend({
      model: function(params) {
        return App.Slide.find(params.slide_id);
      },
      events: {
        previous: function () {
          var id = '' + (+this.get('currentModel.id') - 1);
          window.document.location = '#/slides/' + id;
        },
        next: function () {
          App.stateMachine.send('next', this);
        },
        first: function () {
          window.document.location = '#/slides/' + 0;
        }
      }
    });
    
    // Controllers
    App.SlidesController = Ember.ArrayController.extend({
      sortProperties: ['id']
    });
    
    App.SlideController = Ember.Controller.extend({
      // left = 37, up = 38, right = 39, down = 40
      updateKey: function (code) {
        if (code === 37) {
          this.get('target').send('previous');
        } else if (code === 39) {
          this.get('target').send('next');
        } else if (code === 38) {
          this.get('target').send('first');
        } else if (code === 40) {
          this.get('target').send('last');
        }
      }
    });
    
    // Views
    App.SlidesView = Ember.View.extend({
      classNames: ['slides']
    });
    
    App.SlideView = Ember.View.extend({
      classNames: ['slide'],
      keyDown: function(e) {
        this.get('controller').send('updateKey', e.keyCode);
      },
      didInsertElement: function() {
        $('head title').text(
            ['Using Ember.StateManager', this.get('context.model.filename')].join(' | ')
        );
        return this.$('input').focus();
      },
    });


**javascript/slide-deck/fixtures.js**

    App.Slide.FIXTURES = [
      { id: '0', filename: 'http://fpoimg.com/800x600?text=Title'},
      { id: '1', filename: 'http://fpoimg.com/800x600?text=Section-A', milliseconds: 1000 },
      { id: '2', filename: 'http://fpoimg.com/800x600?text=Slide-A1', milliseconds: 500 },
      { id: '3', filename: 'http://fpoimg.com/800x600?text=Slide-A2', milliseconds: 250 },
      { id: '4', filename: 'http://fpoimg.com/800x600?text=Slide-A3' },
      { id: '5', filename: 'http://fpoimg.com/800x600?text=Section-B', milliseconds: 300 },
      { id: '6', filename: 'http://fpoimg.com/800x600?text=Slide-B1', milliseconds: 300 },
      { id: '7', filename: 'http://fpoimg.com/800x600?text=Slide-B2', milliseconds: 300 },
      { id: '8', filename: 'http://fpoimg.com/800x600?text=Slide-B3' },
      { id: '9', filename: 'http://fpoimg.com/800x600?text=The End'}
    ];    


### Styles

**css/style.css**


    html, body {
        margin: 0;
        padding: 0;
        text-align: left;
    }
    .slides img {
        max-width: 102px;
        max-height: 77px;
        float: left;
        display: inline-block;
    }
    .slide {
        text-align: center;
        position: relative;
        top: 0;
        margin: 0;
        border: 0;
        padding: 0;
        height: 100%;
        overflow: hidden;
    }
    .slide input {
        position: absolute;
        display: block;
        left: -999em;
    }
    .slide img {
        height: 100%;
        border-style: none;
    }


## Observations on using Ember.StateManager

Ember has some awesome tools baked into the framework. The StateManager is an example of an object to mange the state of objects like models, routes, or any object that needs to behave according to it's state.

I few things I noticed when using Ember.State objects:

* Action handlers for `enter` and `exit` may not have the `currentState.name` in the state that you expect, these events happen during transition to/from a state. 

* The `setup` method does have the `currentState` you would expect and receives the `manager` and `context` objects as arguments, while `enter` and `exit` only receive `manager`.

* A state's methods for `enter` and `exit` are good for handling common behaviors when transitioning to sub-states. The `setup` method can be defined in a base state class as the  default setup action for states and thier child states as well.

* Methods defined on a parent state are shared with sub-states.

* Utilize the state pattern by defining the same action methods with varying outcomes depending on the state's required behaviors.

* Reading the 'ember-states' test suite ([state_manager_test.js][5] & [state_test.js][6]) reveals everthing you want to know about the `Ember.StateManager`.

* A state machine may be useful for: 
  * Interactions that don't need to be persisted and represented via a URL.
  * Workflow, e.g. multiple steps to accomplish an objective.

See the [State Pattern][7] for another example of a state objects used to handle various behaviors of mouse activity.

[0]: http://emberjs.com/api/classes/Ember.StateManager.html
[1]: https://github.com/pixelhandler/ember-example-turnstile
[2]: https://github.com/pixelhandler/ember-slide-deck
[3]: https://en.wikipedia.org/wiki/Finite-state_machine
[4]: http://jsbin.com/uvucuw/8/
[5]: https://github.com/emberjs/ember.js/blob/master/packages/ember-states/tests/state_manager_test.js
[6]: https://github.com/emberjs/ember.js/blob/master/packages/ember-states/tests/state_test.js
[7]: http://en.wikipedia.org/wiki/State_pattern