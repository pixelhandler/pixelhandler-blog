---
title: Refreshed my Blog with Express and Ember.js
slug: refreshed-my-blog-with-express-and-emberjs
published_at: '2014-03-02'
author: pixelhandler
tags:
- Ember.js
- Node.js
meta_description: |-
  For the past few weeks I worked on tooling for developing Web applications, written with
  JavaScript, on both the client and the server apps. In addition to u...
---

I always like to have a personal project to experiment with new technologies and also to
sharpen my skills as a software developer. I felt it was time to build a site using 
[Node.js][node.js], so I used [Express] to communicate JSON to the client application.
I chose [RethinkDB] as it stores data in JSON docs, and I can backup the data in JSON too. Finally for the client application I chose [Ember.js]; I've been using Ember for about a
year and dig building JavaScript applications with the libraries Ember provides.

I still host the client application with Amazon S3, but needed to add an API server. I have
a friend that is very happly with [DigitalOcean] so I figured it was time to try them out.
But first I had to build something.

I started off with tooling I found useful for writing a library of extensions for Ember Data.
For build tools I used [Brunch] and wrote a few shell scripts in Bash and Node. I begin by
Setting up api endpoints for the blog posts and writing an adapter for RethinkDB. I wrote (request) tests with [mocha], using [supertest] / [superagent]. Feeling very confident that
the API was doing it's CRUD work I moved on to the client application.

For testing the client app I used [QUnit] with integration test helpers from the [Ember Test]
package that is included with Ember.js. Rather than mock the data, I figured hackers don't
mock; so I went ahead with actual full stack integration testing. I wrote some JSON and a
shell script to seed the database. Eventually I used that same module of JSON docs on both the client and server test suites to assert/expect that the desired functionality with the
data was achieved. With the tests passing for the API writing (request) driven integration
tests for the client worked out smoothly using the Ember test helpers. 

After a few iterations on the client and server It was great to execute the automated tests
and know what broke and what needed rework. I choose not to focus on writing unit tests as
this is a blog app and I'm mostly using the objects that Ember provides. Both Express and
Ember.js have good test coverage for the APIs the libraries support. (At least I think so.)

I have to say that I was very pleased with the choices of libaries, frameworks for this
project; as well as being very happy with the hosting choices as well. DigitalOcean had
great how-to articles for using Ubuntu, the IRC chat rooms for RethinkDB, Ember.js are
very helpful. It was a nice surprise that with RethinkDB I could dump JSON right out of the
database.

Here are links to the repositories I used to build this blog site:

* [ember-app-builder] - my tooling setup
* [pixelhandler/blog] - the client / server application code, and testing suites

A few things may be **broken** until I finish the migration to the new system:

* Previous links need to be redirected to the new routes
* The site may never work in IE (just kidding, but I haven't tested it yet)

[ember-app-builder]: https://github.com/pixelhandler/ember-app-builder
[pixelhandler/blog]: https://github.com/pixelhandler/blog
[node.js]: http://nodejs.org
[Express]: http://expressjs.com
[RethinkDB]: http://www.rethinkdb.com
[Ember.js]: http://emberjs.com
[DigitalOcean]: https://digitalocean.com
[Brunch]: http://brunch.io
[mocha]: http://visionmedia.github.io/mocha/
[supertest]: https://github.com/visionmedia/supertest
[superagent]: https://github.com/visionmedia/superagent
[QUnit]: https://qunitjs.com
[Ember Test]: http://emberjs.com/guides/testing/integration/