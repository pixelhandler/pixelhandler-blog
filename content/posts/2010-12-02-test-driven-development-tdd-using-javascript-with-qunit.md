---
title: Test-driven Development (TDD) Using Javascript With QUnit
slug: test-driven-development-tdd-using-javascript-with-qunit
published_at: '2010-12-02'
author: pixelhandler
tags: []
meta_description: "### Who writes tests anyway?\n\n  * jQuery uses QUnit \n\nDocs:
  [http://docs.jquery.com/Qunit](http://docs.jquery.com/Qunit)\n\nCode: [https://github.com/jquery/qu..."
---

### Test-driven development (TDD) :

A software development process that relies on the repetition of a very short
development cycle: **first** the developer writes a **failing automated test
case** that defines a desired improvement or new function, **then** produces
**code to pass that test** and finally refactors the new code to acceptable
standards.

ref: [http://en.wikipedia.org/wiki/Test-
driven_development](http://en.wikipedia.org/wiki/Test-driven_development)

### Behavior-driven development (BDD)

Introducing BDD : [http://blog.dannorth.net/introducing-
bdd/](http://blog.dannorth.net/introducing-bdd/)

_"…where to start, what to test and what not to test, how much to test in one
go, what to call their tests, and how to understand why a test fails."_

Basically use language/terminology that everyone on the project understands;
using a pattern (e.g. Given, When, Then.) to test expected behavior.

_"Developers discovered it could do at least some of their documentation for
them, so they started to write test methods that were real sentences."_

### This article is about…

  1. Using QUnit with test-driven development (TDD)
  2. Example: utility method for weekend (only) content
  3. First, write tests to describe the expected behavior that fail
  4. Next, code to pass the tests
  5. **The result**: a short utility function, the test script describes what the code does (behavior), is unit tested, and doubles as documentation for the code.

### TDD Process

  1. Add a test
  2. Run all tests and see if the new one fails
  3. Write some code
  4. Run the automated tests and see them succeed
  5. Refactor code
  6. Repeat

_"Test-driven development constantly repeats the steps of adding test cases
that fail, passing them, and refactoring. Receiving the expected test results
at each stage reinforces the programmer's mental model of the code, boosts
confidence and increases productivity."_

_- Lather, Rinse, Repeat_

### Maybe the task is worth it…

**From marketForce :** For weekend traffic, the one word difference had a +17.58% RPV Lift (98.01% Confidence) and a +16.15% Conversion Lift (97.53% Confidence) _So, I think it’s worth…_

– this forecasts to an incremental **$XXX,000** in annual revenues.

### Time will only tell…

Could have used…

    
    
      var today = new Date(); 
      if (today.getDay() == 0 || today.getDay() == 6) { 
        $('#dr_billingContainer h3:eq(0)').html('XXXX XXXX');
      }
    

…Instead chose to make a jQuery plugin that acts as a utility method that can
easily be reused for other sites

> Javascript is all about behavior. Begin by writing some use cases or stories
of what users will experience.

### Plugin / utility method :  TODO…

    
    
      /**  
       *  $.fn.isWeekend() plugin to test if browsing on Sat./Sun.
       *  checks a date object to see if the day is a weekend day, Saturday / Sunday
       *  requires Date object as argument and jQuery
       *  dr.isWeekend alias for plugin to use as utility function
       *  @return true/false
       */
    

What's Needed? What behavior will we test for?

  * is dr a global variable.
  * dr.isWeekend() expects argument of object type Date
  * dr.isWeekend() plugin returns true or false for each day of the week

### QUnit : Start w/ HTML

    
    
    <!DoCtYpE html>
    <html>
      <head>
        <!-- QUnit CSS, JS, etc. -->
      </head>
      <body>
        <h1 id="qunit-header">QUnit Tests for ...</h3>
        <h2 id="qunit-banner"></h2>
        <div id="qunit-testrunner-toolbar"></div>
        <h2 id="qunit-userAgent"></h2>
        <ol id="qunit-tests"></ol>
        <div id="qunit-fixture">test markup</div>
      </body>
    </html>
    

### What does this look like? Let's see it in action with JSFIDDLE

> Tip: click the 'Result' tab to see test results; then click the test to
expand (0, 1, 1) and see the details.

### Setup testing : [JSFIDDLE](http://jsfiddle.net/pixelhandler/NwPD5/)

### Write a test : to fail

    
    
      /* namespace */
      module('namespace check');
      test('is dr a global variable.',function(){
          expect(1);
          ok( window.dr, 'dr namespace is present');
      });
    

### Add namespace test :  …fails

### Add some code :

    
    
      if (!window.dr) { var dr = {}; } // using dr as namespace
    

### Code for namesapce :  …passes

### Add some helper code :  in a module

    
    
      module("dr.isWeekend() utility fn uses jQuery", {
        setup: function() {
          dr.date = new Date();
          dr.weekdays = [1,2,3,4,5];
          dr.weekends = [0,6];
        },
        teardown: function() {
          delete dr.date;
          delete dr.weekdays;
          delete dr.weekends;
        }
      });
    

### Add a module w/ fixture : to run with each test

### Add a test :  Arrange, Act, Assert

    
    
      test("dr.isWeekend() expects argument of object type Date", function(){
          // Arrange - use setup() for dr.date
          var testPluginDefault;
          // Act
          testPluginDefault = dr.isWeekend();
          // Assert
          expect(1);
          notStrictEqual( testPluginDefault, 'error', "Plugin does not return 'error' comparing with notStrictEqual");
      });
    

### Test for plugin / method :  …fails

### Code for plugin :  skeleton

    
    
      (function($) {
    
      $.fn.isWeekend = function(options) {
          var defaults = {};
          opts = $.extend({},defaults, options);
          // return this.each(function() { 
              // code plugin here ...
          // });
      };
      dr.isWeekend = $.fn.isWeekend;
    
      })(jQuery);
    

### Code for plugin skeleton :  …passes

### Add more to the test :  date object?

    
    
      test("dr.isWeekend() expects argument of object type Date", function(){
          // ...
          failDate = [];
          testPluginFalse = dr.isWeekend({ date: failDate });
          // Assert
          expect(2);
          // ...
          equal( testPluginFalse, 'invalid', "Plugin returns sting 'invalid' if argument is not Date object");
      });
    

### Add more to the test :  …fails

### Work it out :

    
    
      $.fn.isWeekend = function(options) {
          var defaults, opts;
          defaults = { date: new Date() };
          opts = $.extend({},defaults, options);
          if (Object.prototype.toString.call(opts.date) === '[object Date]') {
              opts.dateOk = true;
          } else {
              return 'invalid';
          }
      };
    

### Code to :  pass the test

### More testing :

    
    
      // Act
      // ...
      testPluginTrue = dr.isWeekend({ date: dr.date });
      // Assert
      expect(3);
      // ...
      notStrictEqual( testPluginTrue, 'invalid', "Plugin does not return 'invalid' comparing with notStrictEqual");
    

### More testing :  …passes, already :)

### Write some tests for logic

    
    
      test("dr.isWeekend() plugin returns true or false for each day of the week", function(){
          // Arrange - use setup() for dr.date, dr.weekdays, dr.weekends
          var n, weekday, weekend;
    
          // Act
          n = 0;
          weekend = $.inArray(n, dr.weekends);
          n = 1;
          weekday = $.inArray(n, dr.weekdays);
    
          // Assert
          expect(2);
          equal(weekend, 0, "testing a weekend value");
          equal(weekday, 0, "testing a weekday value");
      });
    

### Write some tests for logic :  …passes

### Write some test for behavior :

    
    
      // Assert
      expect(11);
      equal(weekend, 0, "testing a weekend value");
      equal(weekday, 0, "testing a weekday value");
      equal(isSunday, true, "Yes, 11/28/2010 is Sunday a weekend" );
      equal(isMonday, false, "Yes, 11/29/2010 is Monday a weekday" );
      equal(isTuesday, false, "Yes, Tuesday a weekday" );
      equal(isWednesday, false, "Yes, Wednesday a weekday" );
      equal(isThursday, false, "Yes, Thursday a weekday" );
      equal(isFriday, false, "Yes, Friday a weekday" );
      equal(isSaturday, true, "Yes, Saturday a weekday" );
      equal(isTodayAWeekend, true, "Is today a weekend: true if today is a weekend" );
      equal(isTodayAWeekend, false, "Is today a weekend: false if today is a weekday" );
    

### Write some test for behavior :  …fails

### Code the expected behavior :

    
    
      // ...
      weekdays = [1,2,3,4,5];
      weekends = [0,6];
      if (Object.prototype.toString.call(opts.date) === '[object Date]') {
          // check if weekend using getDay() -> returns number 0-6 for day of week
          opts.n = opts.date.getDay();
          if ( $.inArray(opts.n , weekends) > -1 ) {
              return true;
          } else if ( $.inArray(opts.n , weekdays) > -1 ) {
              return false;
          }
          return 'error';
      } else {
          return 'invalid';
      }
    

### 1 fail  … everyday can't be a weekend :(

### Another example :  input helper text

### Another example :  input helper text

### Links :

  * This code - [(github.com) gist](https://gist.github.com/d379c952af637aeb0e51) | [jsfiddle.net ( append 1/ - 11/ )](http://jsfiddle.net/pixelhandler/NwPD5/)
  * This presentation Source - [gist](https://gist.github.com/eee65f0f1d3b82b53ed9)
  * QUnit - [Documentation](http://docs.jquery.com/Qunit) | [Code](https://github.com/jquery/qunit) | [JS](https://github.com/jquery/qunit/raw/master/qunit/qunit.js) | [CSS](https://github.com/jquery/qunit/raw/master/qunit/qunit.css)
  * Notes - [TDD (wikipedia)](http://en.wikipedia.org/wiki/Test-driven_development) | [BDD (blog.dannorth.net)](http://blog.dannorth.net/introducing-bdd/) | [3-A's ](http://integralpath.blogs.com/thinkingoutloud/2005/09/principles_of_t.html)
  * Tools - [jslint.com](http://jslint.com/) | [javascriptcompressor.com](http://javascriptcompressor.com/)
  * Presentation: [Slides](http://skript.co/talks/qunit/)
