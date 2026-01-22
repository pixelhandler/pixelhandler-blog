---
title: A Bet on Web Components and Ember.Component Synchronicity
slug: a-bet-on-web-components-and-embercomponent-synchronicity
published_at: '2015-03-02'
author: pixelhandler
tags:
- Ember.js
- Web Components
- Ember Components
meta_description: What is a native [Web Component] and how does it differ from an
  [Ember.Component]. Can your use of Ember Components reflect the Web Components specification?...
---

This article is a brief overview of both Web Components and Ember Components as well as a comparison of the two. You will see examples of blurring the lines between native Web Components and Ember components. Bits and pieces from the various specification(s), documentation sites and tutorials are highlighted (copied straightaway, follow links to see the full details). *The HTMLRocks tutorials were borrowed (copied) from heavily.*
With the _Ember 2.X Evolution_ under way, you will have a new generation of first class citizens for your DOM, Ember.Components. Perhaps this overview will help you to design your Ember Components with future standards in mind, learn how to use native Web Components in synchronicity with Ember Components, and learn how to upgrade a native Web Component to an Ember.Component.

## An Ember.Component

An [Ember.Component] is a view that is completely isolated.

* Property access in its templates go to the view object
* Actions are targeted at the view object
* No access to the surrounding context or outer controller
* All contextual information must be passed into the component

[Ember.Component]: http://emberjs.com/api/classes/Ember.Component.html

### Commonly Used Properties, Methods & Events…

`tagName`, `layoutName`, `willInsertElement`, `didInsertElement`, `actions`, `sendAction`, `targetObject`, `willDestroyElement`, `$`, `on`, `off`


## A Web Component

A Draft of Specifications:  

* [Template][W3C Template Element] (HTML5)
* [HTMLImport][W3C HTML Imports] (Working Draft)
* [Custom Element][W3C Custom Elements] (Editor's Draft)
* [Shadow DOM][W3C Shadow DOM] (Editor's Draft)

[W3C Template Element]: http://www.w3.org/TR/html5/scripting-1.html#the-template-element
[W3C HTML Imports]: http://www.w3.org/TR/html-imports/
[W3C Custom Elements]: http://w3c.github.io/webcomponents/spec/custom/
[W3C Shadow DOM]: http://w3c.github.io/webcomponents/spec/shadow/

### Template

The [Template][W3C Template Element] element is used to declare fragments of HTML that can be cloned and inserted in the document by script.

When web pages dynamically alter the contents of their documents, they may require fragments of HTML which may require further modification before use, e.g the insertion of values appropriate for the usage context.

`template.content` Returns the template contents, which are stored in a DocumentFragment associated with a different Document (to avoid the template contents interfering with the main Document).

The template element doesn't provide data binding. `<template>` provides an ability to insert 'inert HTML tags' into a document, using inert HTML tags.

* Inlined scripts won't be executed without being stamped out
* Resources such as `<img>` or `<video>` won't be fetched without being stamped out

To define a template, simply wrap your content with a `<template>` tag.

In order to stamp out the `<template>`, you'll need to write a bit of JavaScript.

<sup>Some content in the summaries above were taken directly from the [W3C docs][Web Component] and the [HTMLRocks Tutorials]</sup>

[W3C Template Element]: http://www.w3.org/TR/html5/scripting-1.html#the-template-element
[HTMLRocks Tutorials]: http://www.html5rocks.com/en/search?q=Web+Components

#### More info

* [Introduction to Template Element](http://webcomponents.org/articles/introduction-to-template-element/)
* [http://www.w3.org/TR/html5/scripting-1.html#the-template-element](http://www.w3.org/TR/html5/scripting-1.html#the-template-element)


### HTMLImport

[HTML Imports][W3C HTML Imports] are a way to include and reuse HTML documents in other HTML documents.

_Imports_ are HTML docs, linked as external resources, from another HTML doc. The document that links to an import is called an _import referrer_. An import has an _import referrer ancestor_ as its import referrer.

An import referrer which has its own browsing context is called a _master document_. Each import is associated with one master document.

The URL of an import is called the _import location_. In the import referrer, an import is represented as a Document, called the imported document. The imported documents don't have browsing context.

The set of all imports associated with the master document forms an _import map_ of the master document. The maps stores imports as its items with their import locations as keys.

[W3C HTML Imports]: http://www.w3.org/TR/html-imports/

<sup>Most of the content in the summaries above were copied directly from the [W3C docs][Web Component] and the [HTMLRocks Tutorials]</sup>

#### [Mozilla won't ship HTML Imports][Mozilla and Web Components]
[Mozilla and Web Components]: https://hacks.mozilla.org/2014/12/mozilla-and-web-components/


### Custom Element

[Custom Elements] provides a way for Web developers to build their own, fully-featured DOM elements.

It's possible to create DOM elements with any tag names in HTML, but these elements aren't very functional. Custom elements inform the parser how to properly construct an element & to react to lifecycle changes.

_Rationalize the platform._ The spec ensures that all of its new features & abilities are in concert with how the relevant bits of the Web platform work today

#### Lifecycle: Types of Callbacks

* `createdCallback` - invoked after custom element instance is created and its definition is registered
* `attachedCallback` - whenever custom element is inserted into a document
* `detachedCallback` - whenever custom element is removed from the documen
* `attributeChangedCallback` - whenever custom element's attribute is added, changed or removed.

<sup>Most of the content in the summaries above were copied directly from the [W3C docs][Web Component] and the [HTMLRocks Tutorials]</sup>

[Custom Elements]: http://w3c.github.io/webcomponents/spec/custom/

### Shadow DOM

"A particularly pernicious aspect of the lack of encapsulation is that if you upgrade the library and the internal details of the widget’s DOM changes, your styles and scripts might break in unpredictable ways." -HTMLRocks tutorial

[Shadow DOM][W3C Shadow DOM] addresses the DOM tree encapsulation problem.

Elements can get a new kind of node associated with them, a _shadow root_. An element with a shadow root is a _shadow host_. The content of a shadow host isn’t rendered; the content of the shadow root is rendered instead.

With Shadow DOM, all markup and CSS are scoped to the host element. CSS styles defined inside a Shadow Root won't affect its parent document, CSS styles defined outside the Shadow Root won't affect the main page.

<sup>Most of the content in the summaries above were copied directly from the [W3C docs][Web Component] and the [HTMLRocks Tutorials]</sup>

#### Tutorials

* [Shadow DOM 101]
* [Shadow DOM 201]
* [Shadow DOM 301]

[W3C Shadow DOM]: http://w3c.github.io/webcomponents/spec/shadow/
[Shadow DOM 101]: http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/
[Shadow DOM 201]: http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-201/ "CSS and Styling - HTML5 Rocks"
[Shadow DOM 301]: http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-301/ "Advanced Concepts & DOM APIs - HTML5 Rocks"


## Compare & Contrast…

_How do the two components line up? Can they work together? What are the differences?_

### Ember.Component

* Scope is isolated, only knows the context passed in. Compared with a view that knows the scope of the current controller. Body of component (between the opening and closing tags) is in the same scope of the template it belongs too.
* No encapsulation of styles, best to use a custom element and define a base style for the component.
* You can use in an Ember App today, in any modern browser.
* Specification - only works with Ember.js
* Can use a 'layout' (template); compile with your build pipeline, e.g. ember-cli
* Built-in data-binding (using Ember)
* Lifecycle callbacks (Events): `didInsertElement`, `parentViewDidChange`, `willClearRender`, `willDestroyElement`, `willInsertElement`
* Create components that extend from other components
* Bundle custom functionality into a single component
* Use a custom tagName (custom element)
* How do you distribute components, the Ember CLI 'addons' story is still in its infancy but becoming more attractive

### Web Component: Custom Element

* [caniuse Custom Element](http://caniuse.com/#search=Custom%20Element)
* Feature detecting is a matter of checking if `document.registerElement()` exists
* The most important API primitive under the Web Components umbrella
* Define new HTML/DOM elements
* Create elements that extend from other elements
* Logically bundle together custom functionality into a single tag
* Extend the API of existing DOM elements

    var XFoo = document.registerElement('x-foo', {
      prototype: Object.create(HTMLElement.prototype, {
        bar: {
          get: function() { return 5; }
        },
        foo: {
          value: function() {
            alert('foo() called');
          }
        }
      })
    });

Lifecycle callback methods:  

* `createdCallback` an instance of the element is created
* `attachedCallback` an instance was inserted into the document
* `detachedCallback` an instance was removed from the document
* `attributeChangedCallback(attrName, oldVal, newVal)` an attribute was added, removed, or updated


### Web Component: Shadow DOM

* [caniuse Shadow DOM](http://caniuse.com/#search=Shadow%20DOM)
* Shadow DOM is 'really' completely _isolated_, both in scope (context) and style.
* The shadow root has it's own stylesheet.
* There is a way with CSS to define styles outside of the component using `::shadow` pseudo-element.
* By 'really' _isolated_ we mean there is only a couple backdoors e.g. `::shadow` or `/deep/` using CSS or JavaScript (`querySelector`)
* You can use only in Chrome
* Specification is a work in progress

For example, if an element is hosting a shadow root, you can write `#host::shadow span {}` to style all of the spans within its shadow tree.

_(Code samples borrowed from HTMLRocks tutorials)_

    <style>
      #host::shadow span { color: red; }
    </style>
    <div id="host"><span>Light DOM</span></div>
    <script>
      var host = document.querySelector('div');
      var root = host.createShadowRoot();
      root.innerHTML = '<span>Shadow DOM</span>' + 
                       '<content></content>';
    </script>

Using JavaScript can the shadow tree be accessed? Yes, with the power comes the responsibility to respect encapsulation.

    document.querySelector('x-tabs::shadow x-panel::shadow #foo');

Do the `::shadow` pseudo-element and `/deep/` combinator defeat the purpose of style encapsulation? Shadow DOM prevents accidental styling from outsiders but never promises to be a bullet proof vest.

Developers should be allowed to intentionally style inner parts of your Shadow tree...if they know what they're doing. Having more control is also good for flexibility, theming, and the re-usability of your elements.

<sup>Some of the content above was copied directly from the [W3C docs][Web Component] and the [HTMLRocks Tutorials]</sup>

### Web Component: HTMLImport

* [caniuse HTML Import](http://caniuse.com/#search=HTML%20Import)
* To detect support, check if .import exists on the <link> element `'import' in document.createElement('link')`
* How many imports to you want to link to in the head of a document.
* Perhaps you still need a build pipeline to minimize http requests
* An import is just a document. The content of an import is called an `import` document `$('link[rel="import"]')[0].import;`
* Script in the import is executed in the context of the window that contains the importing document
* Imports do not block parsing of the main page
* The HTML Template element is a natural fit for HTML Imports
* An ideal way to distribute Web Components

### Web Component: Template Element

* [caniuse Template](http://caniuse.com/#search=Template)
* Looks good to go in modern browsers (not Internet Explorer)
* _No built-in data-bindings_, use Object.observe
* [caniuse Object.observe](http://caniuse.com/#search=Object.observe)
* Feature detect `<template>`, create the DOM element and check that the .content property exists - `'content' in document.createElement('template')`
* Content is effectively inert until activated
* Content within a template won't have side effects
* Content is considered not to be in the document
* The .content property is a read-only `DocumentFragment` containing the guts of the template
* Create a deep copy of its .content using `document.importNode()`

    var t = document.querySelector('#mytemplate');
    // Populate the src at runtime.
    t.content.querySelector('img').src = 'logo.png';

    var clone = document.importNode(t.content, true);
    document.body.appendChild(clone);


## Blurring the lines between Web Components and Ember.Component

Below are a few code samples showing how to use the `tagName` of your Ember component that is based on a Custom Element (Web Component).

See the jsbin and github repos for demo links to inspect and see the code in action. Checkout the shadow root in your developer tools to see the shadow root of the Web components.

### Upgrade a native Custom Element into a Web Component  

* See [jayphelps jsbin](http://jsbin.com/hafivocecu/1/edit?html,js,output) (code samples below copied from this jsbin)


    <script type="text/x-handlebars">
      {{input value=value}}
      <x-ember class="blue"></x-ember>
      <x-native foo={{value}} class="red">
        {{value}}
      </x-native>
    </script>

    <script type="text/x-handlebars" data-template-name="components/x-ember">
      I am an ember component
    </script>

Setup component generation...

    window.EmberENV = {
      FEATURES: {
        'ember-htmlbars-component-generation': true
      }
    };

Create a native Web Component...

    // Native Web Component
    function XNativeElement() {}

    XNativeElement.prototype = Object.create(HTMLElement.prototype);

    document.registerElement('x-native', XNativeElement);

    // Upgraded to an Ember Component using `x-native` element
    App.XNativeComponent = Ember.Component.extend({
      tagName: 'x-native',
      attributeBindings: ['foo']
    });

### Upgrading a Web Component to an Ember.Component

* [alert-box-web-components](https://github.com/pixelhandler/alert-box-web-components) - see examples/app.html

I found that in Chrome, which supports Web Components, I can use a Custom Element as the `tagName` for an Ember Component. I reap the benefit from the behaviors provided by the native Web Component and the bindings provided by an Ember Component.

#### Alert Box Web Components Demos

These three demos show examples of using only Web Components, upgrading a Web Component to an Ember Component, and converting the Web Component to an Ember Component.

* [pixelhandler/alert-box-web-components](https://github.com/pixelhandler/alert-box-web-components#alert-box) - Repository for a native Web Component
* [Web Component only](http://pixelhandler.github.io/alert-box-web-components/example/) - Example of the native Web Component in action
* [Ember.js app using (native) Web Component](http://pixelhandler.github.io/alert-box-web-components/example/app.html) - Upgraded Web Component to an Ember Component
* [As an Ember.Component only](http://pixelhandler.github.io/alert-box-web-components/example/ember-component.html) - Borrowed styles and behavior from the Web Component but only done in Ember


#### Alert Box Web Component Code:

    <!--
      Web Component: Alert Box
    -->
    <template id="alert-box">
      <style>
        html {
          box-sizing: border-box;
        }
        *, *:before, *:after {
          box-sizing: inherit;
        }

        /* alert-box */
        :host {
          display: none;
          width: 400px;
          margin: 15px 0;
        }
        :host(.ready) {
          display: block;
        }

        section {
          background-color: #337ab7;
        }
        :host(.red) section,
        :host([type="danger"]) section,
        :host([type="fail"]) section {
          background-color: #D9534F;
        }
        :host(.orange) section,
        :host([type="warning"]) section {
          background-color: #F0AD4E;
        }
        :host(.green) section,
        :host([type="success"]) section {
          background-color: #5CB85C;
        }
        :host(.blue) section,
        :host([type="info"]) section {
          background-color: #337ab7;
        }

        main {
          color: #fff;
          background-color: transparent;
          font-family: 'Fira Sans', sans-serif;
          overflow: visible;
          display: flex;
          flex-flow: row;
          height: 60px;
        }
        section {
          border-radius: 4px;
          margin-right: 2px;
          padding: 0;
          display: flex;
          justify-content: space-around;
          align-items: center;
          flex-flow: row;
        }
        section.notice {
          flex: 10.5 10%;
        }
        section.action {
          flex: 1 10%;
        }
        section.action:hover {
          cursor: pointer;
        }
        aside {
          flex: 1 10%;
          padding: 6px 0 0 0;
        }
        article {
          flex: 9 10%;
        }
        div {
          flex: 1 auto;
          align-self: center;
          text-align: center;
          padding: 6px 0 0 0;
        }
        div .close {
          text-align: center;
        }
      </style>
      <main class="alert-box">
        <section class="notice">
          <aside>
            <content select=".icon"></content>
          </aside>
          <article>
            <content select=".message"></content>
          </article>
        </section>
        <section class="action">
          <div>
            <content select=".close"></content>
          </div>
        </section>
      </main>
    </template>
    <script type="text/javascript" charset="utf-8">
      document.addEventListener('DOMContentLoaded', function () {
        'use-strict';

        window.AlertBoxElement = document.registerElement('alert-box', {
          prototype: Object.create(HTMLElement.prototype, {
            createdCallback: {
              value: function () {
                this.addEventListener('click', this.clickHandler);
              }
            },
            attachedCallback: {
              value: function () {
                if (this.innerHTML !== '') {
                  var template = document.getElementById('alert-box');
                  var clone = document.importNode(template.content, true);
                  this.createShadowRoot().appendChild(clone);
                }
                this.classList.add('ready');
              }
            },
            detachedCallback: {
              value: function () {
                this.removeEventListener('click', this.clickHandler);
              }
            },
            clickHandler: {
              value: function (evt) {
                evt = new CustomEvent('alert-box-click', evt);
                this.dispatchEvent(evt);
                this.parentNode.removeChild(this);
              }
            }
          })
        });
      });
    </script>
    <!--
      Web Component: Icon Info
    -->
    <template id="info-icon">
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
        viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
        <g>
          <path fill="#FFFFFF" d="M51.833,39.464c0,0.919-0.68,1.68-1.76,1.68c-1.04,0-1.72-0.76-1.72-1.68c0-0.92,0.68-1.68,1.72-1.68
            C51.153,37.785,51.833,38.544,51.833,39.464z M48.954,67.899V46.983h2.32v20.917H48.954z"/>
        </g>
        <circle fill="none" stroke="#FFFFFF" stroke-width="2" stroke-miterlimit="10" cx="49.95" cy="50.198" r="29.416"/>
      </svg>
    </template>
    <script type="text/javascript" charset="utf-8">
      document.addEventListener('DOMContentLoaded', function () {
        'use-strict';

        window.IconInfoElement = document.registerElement('icon-info', {
          prototype: Object.create(HTMLElement.prototype, {
            attachedCallback: {
              value: function () {
                var template = document.getElementById('info-icon');
                var clone = document.importNode(template.content, true);
                this.createShadowRoot().appendChild(clone);
              }
            },
          })
        });
      });
    </script>
    <!--
      Web Component: Icon X
    -->
    <template id="icon-x">
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
        viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
        <g>
          <path fill="#FFFFFF" d="M61.059,64.036L49.884,49.837L39.005,64.036h-3.058l12.35-15.459L37.182,35.303h3.176l9.585,11.972
            l9.467-11.972h3.059L51.59,48.451l12.643,15.585H61.059z"/>
        </g>
      </svg>
    </template>
    <script type="text/javascript" charset="utf-8">
      document.addEventListener('DOMContentLoaded', function () {
        'use-strict';

        window.IconXElement = document.registerElement('icon-x', {
          prototype: Object.create(HTMLElement.prototype, {
            attachedCallback: {
              value: function () {
                var template = document.getElementById('icon-x');
                var clone = document.importNode(template.content, true);
                this.createShadowRoot().appendChild(clone);
              }
            },
          })
        });
      });
    </script>

Upgraded Web Component to an Ember.Component...

    <!--
      Upgraded Web Component (to an Ember.Component) used within a template...
      Ember Components utilizing native `<alert-box>` Web Component.
    -->
    <script type="text/x-handlebars" data-template-name="components/countdown-info">
      <p class="message">Info Alert Box, Countdown is Over.</p>
      <icon-info class="icon"></icon-info>
      <icon-x class="close"></icon-x>
    </script>

Ember.Component template for content of native template...

    <script type="text/x-handlebars" data-template-name="components/countdown-warning">
      <p class="message">
        Warning Alert Box w/ Countdown:<br>
        <span class="minutes">{{minutes}}</span> minutes 
        <span class="seconds">{{seconds}}</span> seconds.
      </p>
      <icon-warning class="icon"></icon-warning>
      <icon-x class="close"></icon-x>
    </script>

Ember.Component upgrade from Web Component...

    // AlertBoxComponents and components that extend it upgrade
    // a native Web Component `<alert-box>`

    // NOTE: without alert-box being defined in ember...
    // The feature for `ember-htmlbars-component-generation: true`
    // would bug out on `<alert-box>` used in a template
    App.AlertBoxComponent = Ember.Component.extend({
      tagName: 'alert-box',
      attributeBindings: ['type'],
      type: 'info'
    });

    App.CountdownWarningComponent = App.AlertBoxComponent.extend({
      classNames: ['fixed'],
      attributeBindings: ['minutes:data-minutes', 'seconds:data-seconds'],
      layoutName: 'countdown-warning',
      type: 'warning',
      minutes: 0,
      seconds: 0
    });

    App.CountdownInfoComponent = App.AlertBoxComponent.extend({
      classNames: ['fixed'],
      layoutName: 'countdown-info'
    });

Ember.Component only (not using the Web Component)...

    <script type="text/x-handlebars" data-template-name="components/alert-box">
      <div class="notice box">
        <div class="left">
          {{partial iconTemplateName}}
        </div>
        <div class="middle">
          <p class="message">
            {{yield}}
          </p>
        </div>
      </div>
      <div class="action box">
        <div class="right">
          {{#if hasCloseContent}}
            {{closeContent}}
          {{else}}
            {{partial closeTemplateName}}
          {{/if}}
        </div>
      </div>
    </script>

## I'm betting Ember and Web Components…

I'm really happy with the Shadow Dom and the encapsultation it provides for DOM elements. However, since I can't use that across the board I'm stoked that Ember Components do follow the general patterns for native Web Component. 

I can use a custom `tagName` and benefit from using a custom HTML element. And write CSS that provides the default styles for that Custom Element. Even though the Ember Component does not encapsultate the component's DOM like Shadow DOM does using a shadow root, at least the Ember Component has an isolated scope.

I enjoyed test driving Web Components by authoring an Alert Box Web Component, and was able to borrow from that experiment code that is projection ready, the custom element styles and markup.

I am looking forward to the specification for Web Components taking shape and being implemented in more browsers than just Chrome… so I'm placing my bets that Web Components and Ember Components will live in synchronicity at some point in the near future. Web Components doing all the things they are designed to do, working together with Ember Components providing a simple way to stamp out Web Components and provide some useful data bindings as well as work together, perhaps with Custom Events.

## Thanks to…

* W3C for publishing the [Web Component] specs
* [HTMLRocks Tutorials] for publishing great tutorials on Web Components

_To provide a brief overview of Web Components, I borrowed the content from the two sources above to provide a short summary as highlights of the specifications under the Web Component umbrella._

[Web Component]: http://www.w3.org/TR/#tr_Web_Components
