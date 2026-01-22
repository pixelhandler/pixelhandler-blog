---
title: 'End-to-end Javascript Testing: Integration Tests Using Ember.js Test Helpers'
slug: end-to-end-javascript-testing-integration-tests-using-emberjs-test-helpers
published_at: '2014-03-13'
author: pixelhandler
tags:
- Ember.js
- Testing
meta_description: |-
  In preparation for an application I voluteered to build, I rebuilt my blog with
  [Ember.js] and [Express].  I used test-driven development (TDD) most of the t...
---

* Entire application stack is tested with the integration tests
* The database seed files can be used on the client to confirm rendered templates
  have the expected data
* Since no data is mocked only one set of JSON is maintained with tests, could be
  actual production data
* [Ember Test] helpers are promise driven and work well with [QUnit]
* The testing suites and application code are written in the same language, in my case
  the API is also written in JavaScript
* The tests are executed with the built files, which boosts confidence in shipping
  code to production
* Async issues that come up in testing are most likely real bugs, missed in manual
  browser testing
* Automated test suite runs wickedly fast compared to other testing solutions like
  Selenium (Capybara)

## Screencast: Walkthrough of blog code repository and testing suites

This video runs about 20 minutes and covers the Ember.js blog application this
website is built with, [pixelhandler/blog]. Basically it's a walkthrough of my
integration tests for this blog. The content may be a bit rough, I was a bit tired :)

<video poster="https://s3.amazonaws.com/cdn.pixelhandler.com/uploads/blog-app-integration-tests.png" width="640" height="400" controls>
  <source src="https://s3.amazonaws.com/cdn.pixelhandler.com/uploads/blog-app-integration-tests.mp4" type='video/mp4' />
</video>

* [Video File](https://s3.amazonaws.com/cdn.pixelhandler.com/uploads/blog-app-integration-tests.mp4)

## My Testing Strategy

For this application I had to take a leap of faith in the testing suites of the
libraries I chose to use. My main concern was that the components and features
of the libraries can work together. So, I didn't write any unit tests as I'm
mostly using the libary code as it was designed to be used.

When tests break there may not be a direct relation between the broken tests and
a specific javascript module, but instead the failing test is an indicator of a
broken feature. So I wrote broken acceptance (feature) tests first as often as I
was able to. Then wrote the code to pass the acceptance test.

Hackers don't mock (if thay can avoid it), since the application is speaking JSON
over HTTP... I chose a database that also speaks JSON, RethinkDB. Rethink can
import/export in JSON docs, which comes in handy to create a database seed script
that can be used on the client and the server testing suites.

## Links

* [Source code for the blog application][pixelhandler/blog]
* [Express], build with [node.js]
* [RethinkDB]
* [Ember.js], client testing with [QUnit] and [Ember Test] integration test helpers
* [Brunch]
* [ember-cli]
* API testing: [mocha], [supertest], [superagent]

[pixelhandler/blog]: https://github.com/pixelhandler/blog
[node.js]: https://nodejs.org
[Express]: https://expressjs.com
[RethinkDB]: https://www.rethinkdb.com
[Ember.js]: https://emberjs.com
[Brunch]: https://brunch.io
[mocha]: https://visionmedia.github.io/mocha/
[supertest]: https://github.com/visionmedia/supertest
[superagent]: https://github.com/visionmedia/superagent
[QUnit]: https://qunitjs.com
[Ember Test]: http://emberjs.com/guides/testing/integration/
[ember-cli]: https://ember-cli.com

## UPDATE 6/21/14

I've switched from using [Brunch] to using [ember-cli] so the demo in the video is not up to date with how I use the blog repository with [ember-cli]. The Makefile uses the `ember` command for builds, and launching dev server.