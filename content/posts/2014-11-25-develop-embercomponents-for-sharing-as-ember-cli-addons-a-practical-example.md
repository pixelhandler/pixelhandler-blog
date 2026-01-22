---
title: Develop Ember.Components for Sharing as Ember CLI Addons, A Practical Example
slug: develop-embercomponents-for-sharing-as-ember-cli-addons-a-practical-example
published_at: '2014-11-25'
author: pixelhandler
tags:
- Ember.js
- Ember Addons
- Ember Components
meta_description: Day in and day out, I build JavaScript applications with [Ember.js].
  Occasionally, I am able to pull out a chunk of code and share it on Github. It would
  be ...
---

## Converting a Micro Library of Components to an Ember CLI Addon

I have a simple micro library of components that I wanted to convert to an [Ember CLI] Addon. The [Ember Off Canvas Components] repository contains a group of Ember.js Components that interact to create an [Off Canvas] layout for use in a web application (powered by Ember). Here is an example of that interface included in another library: [UIkit Off-canvas]. I'm betting on the idea that most developers would rather pick a component (for the needs in the application they are creating) versus pick an entire UI library that has some common functionality.

I was inspired by the [Liquid Fire] packaging which includes standalone files with each release for developers who are not yet using Ember CLI. The [developing addons] documentation for Ember CLI outlines the process of creating an Addon. I found that the [packaging][Liquid Fire packaging] scripts in the Liquid Fire repository were straight forward and a good template for including a secondary build of a standalone release.

Prior to converting the off canvas components library to an addon I used [Emberella Component Blueprint] which provided great tooling for component development. Most of the successful platforms or content management systems that I've used over the past ten years has some type of a marketplace, bundle or packing solution for extending a framework. The [Ember Addons] website aggregates and provides a searchable collection of ember addons (NPM packages tagged with the ember-addon keyword). Which is a desirable way to share and find extensions for developing applications with Ember.js.

I was on the fence for some time about using Ember CLI addons for components, at first it seemed that addons should be for tooling only; specific to extending the functionity (tooling) that Ember CLI provides. However, after some consideration and after using the standalone release of Liquid Fire it seemed to me that the time was right to give components (as addons) a chance. I've used Ember CLI for some time and now use it during my day job too. I've found that using a common set of development tools is desireable. I like using Testem, Broccoli, Ember QUnit helpers; for me, (my personal) developer happiness increases when I can standardize the way I develop for both applications and libraries. I expect that it would also be a nice-to-have for developers who may eventually work on code I've shipped, perhaps someone like Elad <https://twitter.com/Elad/status/537037555154554880>.

## A Practical Example

So here is a practical guide on how to develop an addon for a component or group of components that work together...

The [Ember 2.0 RFC] mentions "...communication between components is often most naturally expressed as events or callbacks." which resonates with me. The off-canvas components addon facilitates communication between components using browser events (and bubbling). I did not use any bindings between components or a special dependency as an evented mediator between the components. The browser already provide events, so the components simply talk via custom events which need to be registered with [Ember.Application.customEvents]

Since I've already shipped the off-canvas components library and it's used in a production application, I thought that it would be a valuable exercise to convert from a custom build to a more common build using Ember CLI. So, I started with following the docs for [developing addons]. But, I quickly found myself scratching my head. As I followed the guide, questions like "How do I..." and "Why do I do this..." began to interupt me. I hope that this replay of the process I found successful (in buiding an addon of components) will help others find some clartity.

If you are interested, perhaps peruse my [commit history] while converting over. from commit/0df9223 on 11/19/14 thru 63b84d8 on 11/22/14.

As I followed the docs and attempted to create an addon, I took note of a few topics that interested me or caused some curiosity.

I took the approach of using the `addon` folder for the components source code and importing the prototypes in the `app` directory. This seemed like the best way to provide a component that can be used as-is; and can be easily extended or changed at-will by the consuming application developer who may need to extend or re-open the prototype in their own application source code.

[Ember.js]: http://emberjs.com
[Ember.Component]: http://emberjs.com/api/classes/Ember.Component.html
[Web Components]: http://webcomponents.org
[Ember 2.0 RFC]: https://github.com/emberjs/rfcs/pull/15
[Ember CLI]: http://www.ember-cli.com
[Ember Off Canvas Components]: https://github.com/pixelhandler/ember-off-canvas-components
[Off Canvas]: http://jasonweaver.name/lab/offcanvas/
[UIkit Off-canvas]: http://getuikit.com/docs/offcanvas.html
[Liquid Fire]: https://github.com/ef4/liquid-fire
[Liquid Fire packaging]: https://github.com/ef4/liquid-fire/tree/master/packaging
[Emberella Component Blueprint]: https://github.com/realityendshere/emberella-component-blueprint
[developing addons]: http://www.ember-cli.com/#developing-addons-and-blueprints
[Ember Addons]: http://www.emberaddons.com
[Ember.Application.customEvents]: http://emberjs.com/api/classes/Ember.Application.html#property_customEvents
[commit history]: https://github.com/pixelhandler/ember-off-canvas-components/commits/master


## Start by Generating the Files you Need

The docs suggest using the `ember` command to generate an addon then to generate the building blocks you will include in your addon.

`ember addon ember-off-canvas-components` is the command I used to kick off the scaffold of my converstion to an addon.

Next, use the `ember generate component` command to create the basic files you need for a component, including unit test files.

You can update the test with any test code you've already written or perhaps take the opportunity to mint a fresh new test.

To begin, a super simple test should fail, if you add an assertion for using [Custom Elements]. ([Web Components] use [Custom Elements], right?)

[Custom Elements]: http://w3c.github.io/webcomponents/spec/custom/
[Web Components]: http://www.w3.org/TR/components-intro/

```javascript
import { moduleForComponent, test } from 'ember-qunit';

moduleForComponent('on-canvas', 'OnCanvasComponent');

test('it renders element with tagName on-canvas', function() {
  expect(3);

  var component = this.subject();
  equal(component._state, 'preRender');

  this.append();
  equal(component._state, 'inDOM');
  equal(component.get('element').tagName, 'on-canvas'.toUpperCase(), 'matches `on-canvas`');
});
```

Then I copied over the code for this component (this is the simplest one, all I needed was to use a custom element). After the `ember generate component on-canvas` command I copied the generated code into the `addon/components` directory.

```javascript
import Ember from 'ember';

/**
  To use this component in your app, add this to a template:

  ```handlebars
  {{#on-canvas}}
    {{#off-canvas-opener}}
      <i class="fa fa-bars"></i>
    {{/off-canvas-opener}}
    <div class="on-canvas-body">
      On Canvas Contents
    </div>
  {{/on-canvas}}
  ```

  @extends Ember.Component
*/

export default Ember.Component.extend({
  /**
    The type of element to render this view into. By default, samples will appear
    as `<on-canvas/>` elements.

    @property tagName
    @type String
  */
  tagName: 'on-canvas',

  classNames: ['on-canvas-default']
});
```

Next, I changed the module that was generated, `app/components/on-canvas.js`, to only import the prototype from the addon directory.

```javascript
import OnCanvasComponent from 'ember-off-canvas-components/components/on-canvas';

export default OnCanvasComponent;
```


## What About Initializers?

I mentioned that the components talk using custom events, well the Ember Application will need to register the `customEvents`.

For example on click the component may toggle the display of the off canvas panel like so:

```javascript
click: function (evt) {
  var eventName;
  if (this.get('useToggle')) {
    eventName = 'toggleOffCanvas';
  } else {
    eventName = 'expandOffCanvas';
  }
  Ember.$(evt.target).trigger(eventName);
  return false;
}
```

This requires an initializer to register the custom events I used in the group of components: `toggleOffCanvas`, `expandOffCanvas`, and `collapseOffCanvas`. 

Again, using the command `ember generate initializer custom-events` creates the file I need in the `app/initializers` directory. I did the same thing I did with the component, I copied the generated file to `addon/initializers/custom-events.js` then pasted and updated the initializer code.

```javascript
import Ember from 'ember';

export function initialize(container, application) {
  var customEvents = application.get('customEvents') || {};
  Ember.String.w('toggle expand collapse').forEach(function (prefix) {
    var name = Ember.String.fmt("%@OffCanvas", prefix);
    customEvents[name] = name;
  });
  application.set('customEvents', customEvents);
}

export default {
  name: 'ember-off-canvas-components/custom-events',
  initialize: Ember.K
};
```

The initializer exports the `initialize` method which I import in the application. This will be come handy as I will need to import this initialzer in the app directory for apps consuming the addon as well as utilize the initializer in the packaging scripts for the standalone release to accompany each release of the addon.

In `app/initializers/eoc-custom-events.js` I added:

```javascript
import { initialize } from 'ember-off-canvas-components/initializers/custom-events';

export default {
  name: 'eoc-custom-events',
  initialize: initialize
};
```

I used a different name for the initializer, as I had some errors in the browser console about the name of the initializer 'custom-events' already being registered. So, I didn't fight it, just added a prefix.

Initializers can be tested too; the ember generator already setup a unit test file. In `tests/unit/initializers/custom-events-test.js`:

```javascript
import Ember from 'ember';
import { initialize } from 'ember-off-canvas-components/initializers/custom-events';

var container, application;

module('CustomEventsInitializer', {
  setup: function() {
    Ember.run(function() {
      container = new Ember.Container();
      application = Ember.Application.create();
      application.deferReadiness();
    });
  }
});

test('it sets customEvents on the application', function() {
  expect(1);

  initialize(container, application);

  var expected = {
    toggleOffCanvas: "toggleOffCanvas",
    expandOffCanvas: "expandOffCanvas",
    collapseOffCanvas: "collapseOffCanvas"
  };

  deepEqual(application.customEvents, expected);
});
```

## What About an Example App for gh-pages?

Ember CLI includes a `dummy` app that you can work with during development with the `ember server` command or use as a demo app with the `ember build` script which builds the dummy app in your `/dist` directory. Here is the [demo] I created with the dummy app.

[demo]: http://pixelhandler.github.io/ember-off-canvas-components/

In `tests/dummy` there are folders for `app`, `config`, and `public`, the makings of an ember application. In the [dummy directory] I added a few files I had already used in the previous iteration of this library (the pre-ember-cli version) as an example app. So I created the needed index controller and route, as well as templates for the application, index and a partial off-canvas template. I copied a few styles to the dummy app too. I needed to update the `tests/dummy/config/environment.js` to add a custom `contentSecurityPolicy` with settings to squelch some noisy errors in the browser console since I used font-awesome, `'style-src'` needed `'unsafe-inline'` and a cdn link. Perhaps research `contentSecurityPolicy` to setup your demo (dummy application) to your liking.

Like developing a application with ember-cli, the `ember server` command rebuilds the source of the dummy app as you edit the code.

[dummy directory]: https://github.com/pixelhandler/ember-off-canvas-components/tree/master/tests/dummy

I used the `ember build` command then copy the output from the `/dist` directory to a separate `gh-pages` branch to share a demo app with the repository on Github.


## So you want to use SASS, me too

I had to consider a few concerns and curiosities in order to include node-sass as a dev dependency. After some trial and error, I found...

1. Brocfile doesn’t import vendor files, index.js does
2. I need a custom script for compiling CSS with node-sass and execute the compile step in the Brocfile
3. No need to include the generated CSS in the repo - .gitignore the compiled CSS file(s)

I ended up writing a script to compile the SASS to CSS and write the style sheet for the custom elements in the `/vendor` directory.

* For SASS I used a directory `addon/styles/scss` for the .scss files, and setup `config/environment.js` with paths for compiling/output.

The compile-css.js script:

```javascript
/* global require, module */
var sass = require('node-sass');
var path = require('path');

module.exports = function (env) {
  env = env || 'development';
  var configPath = path.resolve(__dirname, 'config/environment');
  var config = require(configPath)(env);
  var cssFile = 'vendor/' + config.addonPrefix + '.css';
  var vendorFile = path.resolve(__dirname, cssFile);

  sass.renderFile({
    file: path.resolve(__dirname, config.sassMain),
    success: function(/*css*/) {
      console.log('node-sass compiled', vendorFile.split(__dirname)[1]);
    },
    error: function(error) {
      console.error(error);
    },
    includePaths: [ path.resolve(__dirname, config.sassIncludePath) ],
    outputStyle: (env === 'development') ? 'nested' : 'compressed',
    outFile: vendorFile,
    precision: 5,
    sourceMap: (env === 'development')
  });
};
```

I added a `sass` script to the package.json file, which uses the above compile script, `"sass": "node -e \"require('./compile-css.js')()\""`.

The compile script is called from the Brocfile I expect that the css will be compiled on each change. 

```javascript
/* global require, module */
var EmberAddon = require('ember-cli/lib/broccoli/ember-addon');
var app = new EmberAddon();

require('./compile-css')(app.env);

module.exports = app.toTree();
```

Since the repository now has a dependency to compile SASS to CSS I added a `postinstall` script in the package.json using a shell script `postinstall.sh`:

```bash
#!/bin/sh

echo "postinstall..."

echo "installing bower dependendies"
npm install bower
./node_modules/.bin/bower install

echo "installing node-sass"
npm install node-sass

echo "compiling CSS to /vendor with node-sass"
./node_modules/.bin/node-sass ./addon/styles/scss/main.scss ./vendor/ember-off-canvas-components.css
```


## Ok, Ship It!

If your only targeted users are ember-cli users then just edit the package.json file, perhaps add a .npmignore file and surprise the travis config just works out of the box.

So are you telling me that I can develop [Web Components] and ship them with Ember CLI. No and yes, wait. I plan to do a followup post on using Native Web Components with an Ember component utilizing the strengths of Ember bindings. That's another topic for [Custom Elements], [HTML Imports], [Template] and [Shadow DOM]. Ember Components are currently isolated views, "An `Ember.Component` is a view that is completely isolated... There is no access to the surrounding context or outer controller; all contextual information must be passed in". But remember the Ember 2.0 rfc topic is filled with plans for components. That said developing component will become a significant area of focus for developers working with Ember.

[HTML Imports]: http://w3c.github.io/webcomponents/spec/imports/
[Template]: https://html.spec.whatwg.org/multipage/scripting.html#the-template-element
[Shadow DOM]: http://w3c.github.io/webcomponents/spec/shadow/

That said, the genterated package.json file is already tagged with the `ember-addon` keyword. So you can login and publish at will.

1. `npm login` follow the prompts, of course you will need a [npmjs.org] account
2. `npm publish .` from inside the root directory of your addon

[npmjs.org]: https://www.npmjs.org

### Build, Test and Release

I wrote a script `prepublish.sh` to use in the package.json scripts do the `prepublish` tasks of cleaning, building and executing tests.

```bash
#!/bin/sh

echo "clean vendor directory..."
rm -fr ./vendor/*

echo "build and test..."
ember build
ember test

echo "building global/shim dist files..."
rm -fr ./dist
cd ./packaging
../node_modules/.bin/broccoli build ../dist
```

After considering what will be published and trying out the prepublish script I made a few more tweeks:

* Packaging builds standalone library files (.js and .css) to the main `/dist` directory. See the Standalone section for more details on packaging.
* `config/envrionment.js` file needs development and test envrionment definitions
* Add a `.npmignore` file to ignore the client dependency files for the NPM release.
* in package.json set the main file to index.js

Before I actually published the a release on [npmjs.org] I wanted to provide a standalone release for developers not yet using Ember CLI. You can too, read on...

I added a `clean` script to the package.json and use the clean and prepublish scripts to npm publish a version (npm login req) so prior to `npm login` and `npm publish .` I run `npm run clean`. The `prepublish` script will be run with the publish command.


### Can any Ember Developer Use my Addon?

If you take a few steps to learn [Broccoli] to package up a standalone release. Hey someone has already done the heavy lifting. I'm hoping that the [Liquid Fire packaging] scripts will themselves become an addon.

[Broccoli]: https://github.com/broccolijs/broccoli


## A Standalone Release

With the Ember Off Canvas Components addon/library I included a copy of the Liquid Fire packaing scripts with a few customizations and generalization changes. See the [ember-off-canvas-components packaging] and [packaging README].

The Brocfile.js, registry.js, and wrap.js have a couple generalization changes to use the [addon config]

[packaging README]: https://github.com/pixelhandler/ember-off-canvas-components/blob/master/packaging/README-packaging.md
[ember-off-canvas-components packaging]: https://github.com/pixelhandler/ember-off-canvas-components/tree/master/packaging
[addon config]: https://github.com/pixelhandler/ember-off-canvas-components/blob/master/config/environment.js

Then there is the custom needs for shipping a library aside from Ember CLI. The standalone release of the addon will need to register the components in the Application continer so you can use the fancy helpers in the templates, e.g. `{{#off-canvas}}{{/off-canvas}}` (once HTMLBars lands that will look much more like a component). Also the standalone release will need to run any initializers you provide in your addon.

### Exporting to a Global

Create an `index.js` in the addon folder for exporting the library attached to a global variable with a standalone build, like so:

```javascript
import EOCViewportComponent from './components/eoc-viewport';
import OnCanvasComponent from './components/on-canvas';
import OffCanvasComponent from './components/off-canvas';
import OffCanvasOpenerComponent from './components/off-canvas-opener';
import OffCanvasCloserComponent from './components/off-canvas-closer';

export {
  EOCViewportComponent,
  OnCanvasComponent,
  OffCanvasComponent,
  OffCanvasOpenerComponent,
  OffCanvasCloserComponent
};
```

This above export is not needed by an addon, but I guess you could use it as an entry point if you choose to.


### The Glue

The packaging scripts utilize a glue.js file to meet the needs of shipping a standalone release.

The following is used to ship the library code and provide access on a global variable, `window.EmberOffCanvasComponents` it uses the index.js file in the root of the addon directory to import assign. It also uses a shim to add the container references. Finally, I wrapped the addon's initializer to register custom events using a `ember-off-canvas-components-shim` initializer.

```javascript
/* global define, require, window */
var addonName = 'ember-off-canvas-components';

define('ember', ["exports"], function(__exports__) {
  __exports__['default'] = window.Ember;
});

var index = addonName + '/index';
define(addonName, ["exports"], function(__exports__) {
  var library = require(index);
  Object.keys(lf).forEach(function(key) {
    __exports__[key] = library[key];
  });
});

// Glue library to a global var
window.EmberOffCanvasComponents = window.EOC = require(index);

// Register library items in the container
var shim = addonName + '-shim';
window.Ember.Application.initializer({
  name: shim,

  initialize: function(container) {
    require(shim).initialize(container);
  }
});

// Register Custom Events on the Application
var customEventsInitializer = 'ember-off-canvas-components/initializers/custom-events';
window.Ember.Application.initializer({
  name: customEventsInitializer,

  initialize: function(container, application) {
    var customEvents = require(customEventsInitializer);
    customEvents.initialize(container, application);
  }
});
```

## That's a Wrap

Well now that the repository has tools available using `ember` and `npm run` on the command line. A few scripts were needed for post installation, pre-publishing, compiling CSS, and building a standalone release. Now, the [Ember Off Canvas Components] addon can be found on [Ember Addons] or with `npm search`. Developers can use the library with `npm install --save-dev pixelhandler/ember-off-canvas-components`

Without too much effort, the micro library of Ember Components can be created, tested, released and consumed by application developers.

I'm looking forward to developing and sharing more components as Ember CLI addons.