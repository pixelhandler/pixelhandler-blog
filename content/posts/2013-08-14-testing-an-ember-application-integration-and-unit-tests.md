---
title: 'Testing an Ember Application: Integration and Unit tests'
slug: testing-an-ember-application-integration-and-unit-tests
published_at: '2013-08-14'
author: pixelhandler
tags:
- Ember.js
- Testing
meta_description: |-
  **Learning by Example**

  The [PeepCode] Ordr app is an excellent video tutorial for learning
  Ember.js and also a great example of a browser application for w...
---

1. Try Jasmine because we love BDD
2. Try Mocha because it's newer and it's used with Konacha
3. Try QUnit because it may be better with async tests then the above
   and the Ember.js project uses it anyway
4. Wow Ember.js has testing helpers in the ember-testing package, lets
   rewrite the integration tests
5. Try Pavlov since is provides BDD style spec runner on top of QUnit
6. Just use TDD QUnit test runner

In getting started with the exercise we talked and asked... 

* What is important in testing an app built with Ember.js?  
* Because the Ember.js framework has solid test coverage
for the API it provides, is the main gap making sure an 
application's compontents or modules work together?
* The underlying behavior of the framework features and API should just work,
what should we not test?
* Unit tests are needed, but it would be great to have integration tests that
run super fast in a JavaScript runner.
* Perhaps integration or end-to-end testing is the main objective for
  our exercise.

The results of this exercise are on GitHub:

* Repo: [peepcode-ordr-test] | [wiki][peepcode-ordr-test-wiki]

[peepcode-ordr-test]: https://github.com/Ember-SC/peepcode-ordr-test "Ember-SC Meetup PeepCode Ordr Test Repository"
[peepcode-ordr-test-wiki]: https://github.com/Ember-SC/peepcode-ordr-test/wiki "Guide pages proposed to expand Ember testing guide"

## The Application and Fixture Data

See the [application code] which is a result of completing the tutorial
video which comes with accompanying [fixture data]. To understand what the
application does, see the [Fire up Ember.js video] page which has
diagrams and an nice explanation of the workings of the **Ordr** app.

[application code]: https://github.com/Ember-SC/peepcode-ordr-test/wiki/Guide:-Example-Browser-Application
[fixture data]: https://github.com/Ember-SC/peepcode-ordr-test/wiki/Guide:-Fixture-Data

Scott commented, "it's a reasonable 'smallest realistic' Ember.js
application to 'learn with'".

For testing, we used compiled Handlebars templates instead of the script
elements you see in the tutorial.

**Warning:** this example of testing does cover testing [Ember.Data]
models; Ember.data is not ready for prime time yet. That said,
Ember.Data Fixtures are a nice way to pre-populate application data for
listing and reading data. So, why not test the models? Perhaps we can
learn something about the fixture adapter by testing.

[Ember.Data]: https://github.com/emberjs/data

I would not recommended using the fixture adapter for a production application, 
the tutorial uses fixture data as an example that a browser application can be 
worked on in parallel to the development of a server application which will 
provide the data via an API. 

Using fixture data is an ideal way to facilitate testing of data that, in 
production, comes down the wire via AJAX requests.

### Mocking Models

When using Ember Data with asynchronous testing, things can get crazy.
If your testing suite becomes loaded with intermitent test failures due
to the [model lifecycle], it may be a good idea to mock your models in
your unit tests (when the model is _not_ the subject of the test). See below:

```javascript
App.Model = {
  find: Em.K,
  transaction: { commit: Em.K, rollback: Em.K },
  createRecord: Em.K
};
App.SomeModel = App.Model;
```

When mocking the `DS.Model` interface you can also use spies to assert 
your application works with the model.

[FixtureAdapter]: /guides/models/the-fixture-adapter/ "Fixture Adapter section of the Model guide"
[model]: /guides/models/ "Model guide"
[model lifecycle]: /guides/models/model-lifecycle/ "Models must be loaded and saved asynchronously"

## Testing Setup and Helpers

The [testing/integration guide page] on the [emberjs.com] site is an
excellent source for learning about setting up an application for
testing, a reference for the test helpers that are part of the
ember-testing package and information on adding your own test helpers.

[testing/integration guide page]: http://emberjs.com/guides/testing/integration/
[emberjs.com]: http://emberjs.com

### QUnit Test Runner

See this page on [Testing Setup/Helpers] for the Qunit test runner we
used, as well as an example of custom test helpers.

In this case the testing support code combines the definition of the 
helpers and the execution of code to setup the application for testing.

[Testing Setup/Helpers]: https://github.com/Ember-SC/peepcode-ordr-test/wiki/Guide:-Testing-Setup-Helpers

The example HTML document includes CSS styles to display the working application 
below the QUnit test runner.

While under test the application can use a different root element, we used
`#app-root` to identify the Ember.js applications's root element.

The libraries listed in the HTML test runner are same versions distributed 
with the Ember.js [starter kit] repository, see the starter kit repository
for the lastest recommended versions for building Ember.js applications.

### Setup the Application For Testing

The example is this guide uses two (2) methods to prepare the application for 
testing:

```javascript
App.setupForTesting();
App.injectTestHelpers();
```

Added to the Ordr application is a call to [deferReadiness]
`App.deferReadiness()`, used to perform asynchronous setup logic and defer 
booting the application. The `deferReadiness` call was not included in the 
tutorial video, and requires `App.advanceReadiness()` to run the application 
when not under test.

### Custom Test Helpers

See the [end-to-end tests] page for an example integration test that verifies the 
default route of the Ordr application. A custom test helper is used to confirm 
the route. Below is the helper:

```javascript
Ember.Test.registerHelper('path', function() {
  return testing().path();
});
```

A custom helper object is used to introspect application state. The helpers are 
defined in a support file loaded only during testing.

In the example below, helper methods are defined to assist both integration and 
unit testing. See the Unit Tests and End-to-End tests pages in this guide for 
examples which use custom test helpers: `path()` and `getFoodController()`, 
which are defined in the (support) file below.

```javascript
(function (host) {
  var document = host.document;
  var App = host.App;

  var testing = function(){
    var helper = {
      container: function(){
        return App.__container__;
      },
      controller: function( name ){
        return helper.container().lookup('controller:' + name);
      },
      path: function(){
        return helper.controller('application').get('currentPath');
      }
    };
    return helper;
  };

  Ember.Test.registerHelper('path', function() {
    return testing().path();
  });

  Ember.Test.registerHelper('getFoodController', function() {
    return testing().controller('food');
  });

  // Move app to an element on the page so it can be seen while testing.
  document.write('<div id="test-app-container"><div id="ember-testing"></div></div>');
  App.rootElement = '#ember-testing';
  App.setupForTesting();
  App.injectTestHelpers();

}(window));
```

The `App.rootElement` bas been changed while the applicaiton is under test so 
that both the test report and application are visible in the [QUnit] test runner.

See the [integration] testing page or read the [ember-testing package] code for 
more details on the helpers which facilitate testing asynchronous behavior 
within the application. Also, note that [QUnit] provides `start()` and `stop()` 
methods utilized by the `wait()` method (included with the Ember testing 
helpers). 

Async testing can be challenging, our exercise used the default test 
adapter that ships with the Ember Test package. QUnit provides solid support for 
async testing using it's `start` and `stop` methods which are utilized 
internally in the Ember Test package by the `wait` helper which internally calls 
`Test.adapter.asyncStart()` and `Test.adapter.asyncEnd()`.

**Warning:** This example of custom helpers includes a call to a private method 
of the Ember#Application object `__container__`; since it's used only in the 
helper, only while testing, and in only one function... when the private API 
changes this helper can be updated. This method should **not** be used by the 
application source code at all.


[QUnit]: http://qunitjs.com/ "Default testing library supported by the ember-testing package"
[starter kit]: https://github.com/emberjs/starter-kit "A starter kit for Ember"
[deferReadiness]: http://emberjs.com/api/classes/Ember.Application.html#method_deferReadiness "perform asynchronous setup logic and defer booting your application"
[integration]: /guides/testing/integration "integration testing page"
[ember-testing package]: https://github.com/emberjs/ember.js/tree/master/packages/ember-testing/lib "ember.js / packages / ember-testing / lib"

### End-to-End Tests

See this [end-to-end tests] page for examples of integration tests of a Ember.js
application.

With integration tests executed via JavaScript, not only are test reports 
generated fast, but also various components of the application are tested to 
confirm they work as designed.

Unit tests can be used to confirm each component of the application
_can_ work as designed; however, integration tests confirm that the components 
_do_ behave as expected (i.e. they are working together as designed).

A healthy combination of both unit and integration tests, executed via a 
JavaScript test runner in a browser or in a headless runner (e.g. phantomjs), 
facilitates the practice of test-driven development; and helps to ensure that 
development of Ember.js applications can scale and behave as **ambitious** as 
promised by the Ember.js application framework.

[end-to-end tests]: https://github.com/Ember-SC/peepcode-ordr-test/wiki/Guide:-End-to-End-Tests

#### Testing the PeepCode Ordr Application

In the test modules below `App.reset()` is called during the `setup` routine of
each test, so every test executes in isolation from the other tests, resetting
the application each time.

#### Ember.run

The tests have code that should be executed with the confines of an 
[Ember.run] loop (or queue). When the application is in testing mode the 
automatic invocation of an [Ember.run] queue is disabled. So when creating a 
model or changing properties that are bound or observed, this activity requires 
execution in the scope of an `Ember.run` (callback) function.

[Ember.run]: http://emberjs.com/api/classes/Ember.run.html "wrap your code inside this call"

#### Tables Integration Test Module

Tables have a tab (think of this as an order) listing food items. The 
application uses the UI pattern for a "Master–detail interface". There are six 
(6) tables, each of them have a tab (order with list items). Note that
the model relationship may be defined differently than may appear to the
user of the application. In the application source code, a Food may have 
TabItems and a Tab may have a Table; but this doesn't matter from the
perspective of an integration test.

The module below has three (3) integration tests and use the `visit` helper 
provided by the Ember Test package.

The custom `path()` helper is not part of the Ember testing package and
serves as an example of using your own custom test helpers.

```javascript
module('Ordr App integration tests: Tables', {
  setup: function () {
    App.reset();
  }
});

test('Initial Redirect', function(){
  expect(1);
  visit('/').then(function () {
    equal(path(), 'tables.index', 'Redirects to /tables');
  });
});

test('Displays six tables', function(){
  expect(1);
  visit('/tables').then(function () {
    equal(find('#tables a').length, 6, 'Six tables display');
  });
});

test('Table 2, food menu', function () {
  expect(3);
  visit('/tables/2').then(function () {
    equal(find('div.nine h2').text(), 'Table 2', 'Table 2 heading displayed');
    equal(find('#customer-tab li h3:first').text(), 'Click a food to add it', 'Has call to action text');
    equal(find('#menu li > a').length, 5, 'Has food menu with 5 choices');
  });
});
```

#### Tabs Integration Test Module

The module below uses the following test helpers provided by the Ember
test package:

* `visit` (`then`), `click`

The integration tests visit various routes for a few of the tables and exercises 
the application behaviors of adding food items to a tab (order). Also, a test 
confirms that the state of the tab(s) remains between visits of a couple tables. 
One table has data pre-populated (data defined in the fixures for table #4).

```javascript
module('Ordr App integration tests: Tabs', {
  setup: function () {
    App.reset();
  }
});

test('Tables 1 and 3, adding foods to the tabs', function(){
  expect(5);
  visit('/tables/1').then(function (){
    equal(find('div.nine h2').text(), 'Table 1', 'Table 1 heading displayed');
    return click('#menu li:eq(0) > a');
  }).then(function(){
    equal(find('#customer-tab li:eq(0) > h3').text(), 'Pizza $15.00', 'Added pizza to tab');
    equal(find('#total span').text(), '$15.00', 'Total price updated with pizza price');
    visit('/tables/3').then(function (){
      equal(find('div.nine h2').text(), 'Table 3', 'Table 3 heading displayed');
      visit('/tables/1').then(function (){
        equal(find('#customer-tab li:eq(0) > h3').text(), 'Pizza $15.00', 'Pizza still in tab');
      });
    });
  });
});

test('Table 4, already had foods added to the tab', function(){
  expect(3);
  visit('/tables/4').then(function (){
    var actual = [],
        expectedFoods = 'Pizza$15.00Pancakes$3.00Fries$7.00HotDog$9.50BirthdayCake$20.00Total$54.50';

    find('#customer-tab > li').each(function (){
      actual.push( find(this).text() );
    });
    equal(find('div.nine h2').text(), 'Table 4', 'Table 4 heading displayed');
    equal(actual.join('').replace(/\s/g, ''), expectedFoods, 'Pizza, Pancakes, Fries, Hot Dogs, Cake already added');
    equal(find('#total span').text(), '$54.50', 'Already has $54.50 in foods in the tab');
  });
});
```

### Testing Strategy

The approach of testing an Ember.js application by writing integration
tests does support the concept of writing tests for the design of an
application from a behavioral perspective. Basically testing the user's
interations with your application. I really like that approach as it
does favor writing tests first then writing code to pass your tests. 

This exercise of writing tests for the Ordr app was done after writing
the app via a tutorial video. I do think that with the "async aware"
testing DSL provided by the "ember-testing" package a software
engineer is encouraged to write tests from the perspective of user
interactions. This can be thought of as functional or integration
testing.

Using the Ember-testing package with QUnit affords taming the beast of
async testing.

I look forward to writing tests for application development which support
the design of the application and the user experience. I do prefer to 
avoid writing tests that are basically written to catch bugs when code changes.

Using the ember-testing package I can write tests that describe the
application's behavior. For example `visit` this or that route `then`
assert or expect some thing to be displayed. And, perhaps `find` an input
element and `fillIn` my name or some data; and `click` submit `then` the
test can automatically `wait` for the result of that click event `then`
confirm that the application is routed to the desired page.

This type of testing allows you to start with a simple action like
`visit` a route. With that failing test, you can then write the code in
the router to support the new route. Next, add more to your test using
`then`, to check that a template has the right content for users to get
busy using the app. So, you write a failing test for the items in the
template that are crucial for your users to interact with. Next, write the
code to render your template and the necessary elements should be
displayed passing your test. To continue testing the experience, write a
test to `fillIn` or `click` some part of that template and assert that your
controller or route has an event/action handler that deals with the user
interaction. Once you have a failing test, then work on putting together
the function handlers to complete the desired behaviors.

That's pretty powerful in a speedy JavaScript test runner, and can grow/change
as the scope of your application changes.

Aside from integration tests, there's unit testing. I recommend writing unit
tests to help engineer the features that your application supports. Having
integration tests are great and important; but don't forget to write unit tests
as you develop key behaviours and features... to display, or interact with
single components of the application.

## Unit Tests

See this page on writing [unit tests] for a controller, a handlebars
helper and the models used in the Ordr app.

[unit tests]: https://github.com/Ember-SC/peepcode-ordr-test/wiki/Guide:-Unit-Tests

I found that in some of the unit tests the `visit()` helper was needed to force
Ember Data Fixtures to become ready for testing. In addition to `App.reset()`
some setup may be needed to ask the route to setup the expected application
state, so `visit()` is called during the setup routine.

There is one caveat with this case study and using `App.reset()`. The Ordr App 
is reset with each unit test so the unit test is executed in isolation from 
other tests but the Ordr application code is also running. Instead of reseting 
the application, it may be desireable for the tests of a production application 
to use a new Ember.Application with only the required objects that will be unit 
tested. Then the unit tests would be executed in isolation from the 
application's start routine. This topic fell outside the scope of our exercise,
so I used only the Ordr applicaiton for the unit tests.

### Food Controller Unit Test Module

This tests insures a food can be added to the tab (order). The example tests 
below use a custom helper to lookup the food controller instance 
`getFoodController()`.  

A food record is created within an [Ember.run] queue which helps organize the 
"act" segment of a test. It's common practice in test-driven development 
organize tests in 3 steps: 1-Arrange, 2-Act, 3-Assert.

```javascript
module('Ordr App unit tests: Food Controller', {
  setup: function () {
    App.reset();
    visit('/tables/1');
  }
});

test('Add food to tabItems', function() {
  expect(7);

  var controller = getFoodController();
  ok(controller, 'Food controller is ok');
  ok(controller.addFood, 'Food controller has addFood action');

  var tabItems = controller.get('controllers.table.tab.tabItems');
  ok(tabItems, 'Food controller can access food items');
  equal(tabItems.get('content').length, 0, 'tabItems are empty');

  var cheese, foods = [];
  Ember.run(function () {
    cheese = App.Food.createRecord({
      id: 500,
      name: 'cheese',
      imgUrl: '',
      cents: 100
    });
    controller.addFood(cheese);
    tabItems.get('content').forEach(function(food){
      foods.push( food.record.toJSON() );
    });
  });
  equal(tabItems.get('content').length, 1, 'Added food to tabItems');
  equal(foods.length, 1, 'tabItems has one food');
  equal(foods[0].cents, 100, 'added food cost is 100 cents');
});
```

### Handlebars Helper Unit Test Module

The example tests below exercise the display format of money using a Handlebars 
helper to convert cents to dollars, e.g. 350 cents display as "3.50". Conditions 
are tested to confirm output when the cents value is not a number and when the 
cents value is a number. The helper outputs "0.00" by default, otherwise formats 
the cents as dollars (two decimal places).

```javascript
module('Ordr App unit tests: Handlebars Helper', {
  setup: function () {
    App.reset();
  }
});

test('money helper renders default text', function() {
  expect(2);

  var view, cents;
  Ember.run(function () {
    view = Ember.View.create({
      template: Ember.Handlebars.compile('{{money cents}}')
    });
    view.appendTo('#qunit-fixture');
    cents = view.get('cents');
  });
  equal(cents, null, 'Value is not a null');
  strictEqual(view.$().text(), '0.00', 'Renders 0.00 when NaN');
});

test('money helper renders number converted to money format', function() {
  expect(2);

  var view, cents;
  Ember.run(function () {
    view = Ember.View.create({
      template: Ember.Handlebars.compile('{{money view.cents}}'),
      cents: 777
    });
    view.appendTo('#qunit-fixture');
    cents = view.get('cents');
  });
  equal(cents, 777, 'Value is 777');
  strictEqual(view.$().text(), '7.77', 'Renders 7.77 given 777');
});

```

### Models Unit Test Module

**Warning: This application uses Ember Data, "Use with caution"**

In the schema for the Ordr application...

* A Table belongs to a Tab (order)
* A Tab has many TabItems and a computed property for `cents` subtotal
* A TabItem belongs to a Food
* A Food has a `cents` property that is copied to a TabItem
  (a food price can change but the price in the order is final)

Again, in this test, the setup of the models using fixtures is forced by using 
`visit()` to trigger a route that results in the setup of application state 
under test, specifically the models that rely on fixture data. (This may be an 
anti-pattern, but seemed necessary at this time for testing the models using the
`DS.Model#createRecord` method provided by Ember Data.)

See the [unit tests] page for the functions and variables used to assist creating
model instances during unit testing of the various model classes.

```javascript
module('Ordr App unit tests: Models', {
  setup: function () {
    App.reset();
    visit('/tables/4');
  }
});

test('Tab model has total of all items for table 4', function() {
  expect(3);

  ok(App.Tab, 'Food model ok');
  var tab = getFoodController().get('controllers.table.tab');
  ok(tab, 'tab instance ok');

  var total = 0;
  tab.get('tabItems.content').forEach(function(food){
    total += food.record.get('cents');
  });
  strictEqual(tab.get('cents'), total, '5450 cents is the total of the tab');
});

test('Food model created with name, imageUrl and cents', function() {
  expect(5);

  ok(App.Food, 'Food model ok');
  var food;
  Ember.run(function () {
    food = createCheese();
  });
  ok(food, 'created food item');
  equal(food.get('name'), 'Cheese', 'Food Name is Cheese');
  equal(food.get('imageUrl'), 'img/cheese.png', 'Url is img/cheese.png');
  equal(food.get('cents'), 400, 'cents is 400');

  Ember.run(function () {
    food.destroy();
  });
});

test('TabItem model created with food model and cents', function() {
  expect(2);

  ok(App.TabItem, 'TabItem model ok');
  var tabItem;
  Ember.run(function () {
    tabItem = createTabItem(createCheese(), 400);
  });
  equal(tabItem.get('cents'), 400, 'created tabItem with 400 cents');

  Ember.run(function () {
    tabItem.destroy();
  });
});

test('Tab model created with food models', function() {
  expect(3);

  ok(App.Tab, 'Tab model ok');
  var tab, foods = [], foodsSum;
  Ember.run(function () {
    tab = createTabWithCheeseAndCrackers();
  });
  tab.get('tabItems.content').forEach(function(food){
    foods.push(food.record.get('cents'));
  });
  foodsSum = foods.reduce(function (prev, cur) {
    return prev + cur;
  });
  equal(foods.length, 2, 'created tab with two items');
  equal(foodsSum, tab.get('cents'), 'total of tab is 750');

  Ember.run(function () {
    tab.destroy();
  });
});

test('Table', function() {
  expect(2);

  ok(App.Table, 'Table model ok');
  var table;
  Ember.run(function () {
    table = createTable(createTabWithCheeseAndCrackers());
  });
  equal(table.get('tab.tabItems.content').length, 2, 'created table with tab which already has 2 items');

  Ember.run(function () {
    table.destroy();
  });
});
```

## What Not to Test

Get familiar with the Ember.js framework you are using and spend some
time reading the tests it has, which guarantee that it's own features work.
You can learn how to write tests by learning from those examples. But be
careful not to write tests for your application the same way the
framework tests itself, avoid using or testing Ember.js private methods
and properties.

If the framework has a feature that is tested and works, there is no need
to test that your application can do that. Don't test an observer or
binding unless it's really important for your team to know that the
bound property should work as your test describes it. 

Don't test every element and CSS class your handlebars template
contains, likely that will change fast anyway. Instead, test that your
template fires off the expected actions for your app to respond to.
Likely, you don't need to write a test for every element that can be
clicked by an user.