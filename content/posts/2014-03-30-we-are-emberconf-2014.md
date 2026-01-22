---
title: We are EmberConf 2014
slug: we-are-emberconf-2014
published_at: '2014-03-30'
author: pixelhandler
tags:
- Ember.js
- Conference
meta_description: I missed EmberCamp last year, but am very fortunate to have attended
  EmberConf 2014 this year. Not only did I gain profitable knowledge about a framework
  for...
---

I may have missed a few segments of the presentations or been distracted during a few talks so I apologize in advance to the speakers if I have not included notes from your talks in this article. I can honestly say that I did find value in every presentation. (That has not always been the case when I've attended a conference.) The headings I use in this article may not match the speakers presentation titles. This article captures what I learned from the conference so I've taken liberty to create new headings and combine common topics; besides "Keynote" as a heading lacks context ;)

## Speed, Efficiency, Productivity...

The take away is that by adopting the conventions of the Ember.js framework a developer gets "Speed, Efficiency, Productivity..." by default.

_Flows are just as important as screens_. With Ember you control (users') flow through your Web application using the `Router`. The routing features that Ember provides are more than just URLs. This was proven by more that one presentation on the topic of routing. There was a very impressive presentation later on [fnd.io](https://fnd.io) which used every model known by the application to route any type of object that a search application could identify. And another presentation that injected additional logic to manage transitions between complex states in a banking like Web application.

"Get rid of sinkholes, use commonality" Routing provides strong defaults in how to organize flow and state in a true Web application.

My experience with the router has been that once I grok how to use it the next time I start an application the productivity is noticeable and satisfying. The same can be said of other conventions that Ember.js provides. The concepts in the router are simple and complex at the same time; but the net take away is that using this common way of managing flow and state yields productivity. There is a reward for investing time in learning and using the conventions of routing for a browser application. 

## Frameworks are Designed to Nudge You in the Right Direction

The Vine app for sharing videos is built with Ember and it turns out that using many many videos on a page can be a bit of a challenge in a Web application; especially for creating a snappy user experience. Data visualization can be a complex chore for a team with varying strengths. Ember `Component` can be used to encapsulate complexity of using a 3rd party library like D3 for pretty data on screen. Application code can be built with more than one recipe to deliver a different experience by only changing the dependency for a router file.

I find that once I get the concepts of using components to isolate behavior and reuse it in various contexts that is a very powerful and valuable convention. And Web components are in the not so far off future already. 

_Welcome to the future :)_ (Not really.) But I do think that using Ember components is a peek into what will likely be a shared way build reusable components on the Web in general.

## Contributing

The contributing presentation provided great details on how to get involved and help the community. The TL;DR summary is do try to make it easy for the core team to help you help the community.

It would be a good idea to subscribe to the security email list. Also you can enable feature flags in the beta/release channels of Ember but DON'T DO IT. The fixes to bugs found in new features will not be patched onto those release channels. It's best to use Canary to try and contribute to new features or bugs.

I think this talk exposed a common and priceless value of the Ember community in general... there is a huge value that is given by the core team members as well as those who decide to contribute and any level. This value is sacrificial and comes at a very high price, the time belonging to loved ones. I would conclude that there is a genuine passion for the project itself as well as the people who use the project's codebases.

The fast track to helping with the community is an attitude of others first. Adopting the conventions on how to commit code for a feature or a bug makes peoples lives better.

## Love Trolls

Trolling is common on the interwebs, love trolling not as much. Well, unless you're at EmberConf.

The phase "Just Stop" is all it takes to find common ground between such a wide variety of world views within the development community.

I think this expression represents a care for humans in general, like... "Hey my friend, please don't make a fool of yourself" or, "Hey I just need you to know I'm not ok with that, can we move on to common ground". 

Just as we are capable of introducing bugs to a codebase, we are all capable of hurting others. More important than an awesome framework are awesome people who aren't left out. 

This idea rises above political correctness and just puts others before self; a valuable ethic for any community. And, it's found in the Ember community.

## Data Persistence

### ...A Hard Problem

* Data Transformation
* Asynchrony
* Caching
* Locality
* Relationships

The above are the objectives that Ember Data achieves to solve for Web applications. However it's not as easy as one would expect. When all the above happen together, there be dragons. 

The premise of the Ember Data project are...

1. Easy problems should be locked down less often (give developers more flexibility)
2. Lock down API for hard problem

### ...You're Building A Distributed Computing System

We received a lecture on math theory related to distributed computing systems. There is a trade-off between availability and consistency. Safety (always right) or liveness (eventually there), how would you like your data? A good goal is to build weak consistency with higher availability. Something to consider is that once you send data to a client it immediately becomes a cache of that data (and most likely to become stale quickly).

I forgot how much I enjoy mathematics and theory, it was refreshing to think about the client-server data caching problem from this perspective. A server-based data driven application should know how to manage the data cache sent to it's clients, or perhaps a client application should know it's contract for the data it receives. One thing I'd like to work on is using sockets to manage multiple data stores (caches): perhaps a memory store, a local store (disc) and a remote store communicating with clients via Web sockets.

## Tooling: Build Your App with Broccoli

Remember those little veggie trees? Your application's modules (files) live in trees (folders), the broccoli build library only knows about trees, `read`, `read`, and `cleanup`. The API is small leaving room for adding specific sets of functionality by writing plugins. You can have many plugins and build targets as well as a `mergeTrees` method to package up your application.

Broccoli is for working with files in your repository it's not a task runner. Integration within your tool set can be achieved as you choose, perhaps a grunt task kick off the build.

The benefit of using `broccoli` to build your application is... only files with a change in last modified date are re-processed so the result a super speedy build with each change; even when you have a large set of files (modules) composing your application.

Broccoli is the newest choice of tooling for generating a build for a JavaScript application. And its likely the fastest too. What a considerable contribution to the Ember community. I am looking forward to a speed boost in my development cycles.

## Animation and Transitions, Janky Not Allowed

Why animate? Just because developers understand crazy abstractions, not everyone is "freakish like that". Providing some direction to flow by animating a change gives users a sense of where they are navigating to and how to go back to where they've been. If every link just immediately appeared users would have a limited sense of what the application's flow is. As users transition between screens or even parts of a screen, animation provides some directional context that makes the application feel more natural.

Using Ember there are two types of animations. One is a simple animation within a single route, done with CSS (based on class attributes that belong to a component on the screen). The second is a complex animation between route transitions.

To avoid jankiness in an Ember application it is a good idea to silence browser events so that your application is not listening or responding to irrelevant event handlers. One solution is to add back in needed event handlers by wrapping the code needing the events with a component which does listen for the event. A couple concepts to hook into so wrangle complex animations are using `willTransition` and also named outlets. For thinks like a modal using `query-params-new` allows you to bypass router and reuse the same modal anywhere.

## Angular's Transclusion is not a Misnomer

Transclusion is the inclusion of one thing into something else. It's like using an Ember.Component instance with `yield`. I think the goal of using a directive with transclusion is to encapsulate HTML, CSS and JavaScript, to roll your own reusable widgets. Perhaps a dependent select box is a good example of a Web Component that would utilize Angular directives and transclusion; alternatively, an Ember.Component would be used for the same.

I'm not sure that I really know why there was a Talk on Angular other than to call out that in some cases we are working on common solutions in both development communities; however the techniques and naming may be quite different to achieve the same goal. I did like how the speaker tackled a couple topics which those in the Ember community have poked fun at perhaps at the expense of those in the Angular community. At the end of the day we're all JavaScript developers.

I think that the speaker on the Angular topic was quite brave to take on this topic for a decidedly "Ember" audience. For me the take away is that there are different strokes for different folks; and that's just fine; perhaps we'll learn something from each other of find some common ground in an area like Web components.

## Doing Better with Available API's Using Ember.js

Searching the iTunes Music Store and App store can be at times not so great of an experience, especially on the Web. Apple's  API's to query media types make a good source to build an application built without a backend, and perhaps do a better job on the Web than Apple has done. [Fnd.io](http://fnd.io) is the example that takes on Apple's search experience on the Web platform head on. 

A talk was presented on how to model iTunes Media using Mixins and Ember Data. Using composition to model various data types found in the stores' API gave some flexibility to identify types from an API where it's not always clear what things actually are typed as. The fnd.io site focuses on product search rather than document search.

The value Ember provided was beautiful URLs with a fast product search tool that rivals any experience searching for iTunes and App store products on the web.

"Tapas with Ember" (Brunch recipe) may have been a result of this project which uses Brunch for a build tool.

## 2X-3X Performance Boost Coming Soon: HTMLBars

The project is still in an alpha stage; though it was not possible to release an alpha version for EmberConf2014 serious effort was made to do so. The promise is 2X-3X times speed gains once HTMLBars ships. I'm looking forward to kissing metamorphs good-bye and saying hello to "fast" with HTMLBars.

Some of the differences in HTMLBars are:

* Unlike Handlebars HTMLBars understands your markup
* Builds DOM fragments instead of Strings
* No more `script` tags (MetaMorphs)
* Large lists are much more performance, as the source uses `clone`
* Binding update order
* Stop recursion / Limits re-render (anti-pattern)
* Simplicity in the markup, removes the need for helpers like `bind-attr`

Ultimately the goal of HTMLBars is to step into a simpler primitive.

I could tell that the team working on the project was a bit spent and also sensed that a significant sacrifice of personal time has been invested in toward increased performance for the Ember community. Thanks for the hard work guys; and thanks to your loved ones for leasing you to the Ember community for this project.

## Reusable Views: Components

A couple questions to ask when considering to create a component are:

* Does it have behavior?
* Does it need to use a specific class or action?

Good examples are `form` with `input type=submit`; and `select` with `option`. The behavior of a form change when there is a submit input element.

Some advice given regarding building with Ember:

* Don't build large components with big templates
* Do use composite components; lean on using no templates
* Test and develop with dynamic data
* Build native Ember components rather then using Bootstrap
* Child components should inform parent they exist to change behavior, `willInsertElement` is a good hook to use

`ic-tabs` and `ic-menu` component micro-libraries were demonstrated. I good goal for an architect of an application is to measure success by the frequency that your team asks how to use the apis provided to the application developers. Using components to abstract complexity and provide consistency may reduce the amount of support needed. Also using method names that define the action and combining the `.on('eventName')` extension to the method helps communicate the how and why of the methods contained in your components. Thank you [Instructure](https://github.com/instructure) team, for contributing these components to the Ember community.

## Ember AppKit Gives Birth to Ember CLI

`ember-cli` is the child project conceived by the bleeding edge work done on Ember App Kit (EAK). While creating new tooling for Ember projects, the EAK project tackled various problems and paved the way to abstract many solutions. Using Ember App Kit allows developers to ship real stuff and also experiment with solutions at the same time. It's my opinion that good things come from real apps. So, thank you to those to felt comfortable living on the bleeding edge, your pains have born `ember-cli`.

Some of the byproducts of the EAK project are:

1. *Problem*: Coupling / *Solution*: Inversion of control, `resolver` knows/finds in `container`
1. *Problem*: Assemble Source / *Solution*: Build Tooling
1. *Problem*: Upgrade nightmares / *Solution*: Better abstractions, hide nearly all the complexity
1. *Problem*: Copious bugs / *Solution*: Thorough test suite
1. *Problem*: Build Stability / Solution: Tool choice, build pipeline with Broccoli

_"When a problem comes along you must whip it"_ - My perception of EAK's theme

`ember-cli` is the single place to focus using the solutions above. You can help too! A call to action was echoed from the podium, "we need a good story for fingerprinting". (Perhaps using md5 hash in asset filenames and updating links to assets using the same hash.) This is not a new problem but needs a good story for JavaScript applications.

Perhaps the most noticeable result of EAK was the adoption of using es6 modules in Ember applications today. (Welcome to the future.)

## Give Back, You Can Make a Difference

You can teach a web development class as long as your students can type. DeVaris Brown did just that, and proved that it's possible to teach 16 to 19 year old kids Web development. His story was amazing, heartfelt and received with many cheers and tears alike. As developers we have a highly valuable skill and DeVaris has carved out curriculum for teaching the basic building blocks of Web development to kids. Sounds like madness no? Well for Devaris there were more than a few magical moments. He said that the kids "liked the magic of the Ember.js framework". This was caught after kids asked if there was another way beside copy and paste to create Web pages. Aha, you can build dynamic web pages with Ember.js; magic right! It appears so.

What Devaris strived to do was make a difference for underprivileged kids using what he knows. He learning that the basic requirement for accepting students is the ability to type; he discovered that people can do good in their communities. The kids worked on a project to support connecting people, foodbanks, and food providers; how awesome that is!

Imagine explaining the DOM to kids and teaching HTML, CSS, and JavaScript basics. Devaris committed to sharing his curriculum (a collection of Markdown files) on github. He also mentioned that he found [typing.io](http://typing.io) to be a good tool to help with the typing challenges, "kids only use a few characters while texting".

I was very impressed with how Devaris hung in there until that **aha** moment when the kids caught it; Devaris was like "Thank you Jesus!" and we all were clapping and crying. Nice work Devaris, you made a difference and inspired others to do the same.

## Who Owns Query Params, Router or Controller?

Mr. Router thought that the `Router` should own query params, yet there was a convincing case for the `Controller` to manage these variables. `query-params-new` has a controller-centric API.

There is a problem to solve, controller property stickiness, perhaps a new primitive "model dependent state" may be the resolution. This concept (vaporware at this point in time) would scope controller state to a model instance. The issue of controller stickiness is not unique to query-params.

My take away is that things that seem simple can become hard; and until a feature becomes stable it remains behind a feature flag like `query-params-new`.

## Ember.js Testing is Not Hard, It's Unknown

The `ember-qunit` project has a great concept that makes testing an Ember application much easier that is has been in the past. The `resolver` is used to pluck out the subject of the test into an new container which sets up a sandbox for unit testing.

Ember's testing backstory (the happy path using QUnit) was presented with funny slides. It's been a year since we've had the `ember-testing` package, and there has been additional helpers added to the project as well.

Integration testing is fairy straight forward and now with `ember-qunit` unit testing has an improved story. To setup and insert the test helpers call `setupForTesting()` and `injectTestHelpers()` on your application namespace. The (global) helpers are `visit`, `click`, `fillIn`, `find`, `findWithAssert`, `keyEvent`, `andThen`; the newest are: `triggerEvent`, `currentRouteName`. See the API docs for more info on using the helpers.

Perhaps the best way to get started with reading example tests:

* [jsbin.com/suteg](http://jsbin.com/suteg/7/edit?html,js,output)
* [jsbin.com/cahuc](http://jsbin.com/cahuc/1/edit?html,js,output)
* [jsbin.com/qifon](http://jsbin.com/qifon/5/edit?html,js,output)
* [jsbin.com/numof](http://jsbin.com/numof/9/edit?html,js,output)
* [jsbin.com/witut](http://jsbin.com/witut/7/edit?html,js,output)
* [jsbin.com/kilej](http://jsbin.com/kilej/3/edit?html,js,output)

And also, don't forget to checkout the new guide in progress:

* [Initial PR for ember testing guide redux](https://github.com/emberjs/website/pull/1401)

I had taken a stab a writing a testing guide awhile back, [website/pull/610](https://github.com/emberjs/website/pull/610/files), which I closed out as the testing story was still a bit painful and we really needed something like `ember-qunit` to evolve and simplify isolating tests.

Thanks to everyone involved in helping the Ember testing story evolve from painful to simple; I'm looking forward to an awesome testing guide.

## Controlling Flow in the Router

Traversing routes to enforce a specific flow event with optional flows can be achieved. The example presented was a login flow to a backing application with various options that depend on the user's choices made while stepping through this flow.

When designing flows, start by a) listing every single permutation, b) inventory all routes, c) list linear paths, d) contain state modification on nodes, by describing state on each node;  finally e) traverse backwards (back button). The route's `replaceWith` method is well suited for using custom flow.

The project presented is [ember-flows](https://github.com/nathanhammond/ember-flows); which is a great example of extending functionality by injecting an object into your application container.

The object used in to define flow strategy has properties for `from` (route path), `to` (route path), `weight` (number), and `conditions` (Array). And the hook used to enforce the flow is `beforeModel` like so `this.get('flow').check();`. The flow object injected into the application can make a choice about when to change paths in the router using `replaceWith`. Well hopefully I grokked it correctly see the `ember-flows` project if you'd like the details.

Again I's great to know that there are solutions that are essentially plugin-able to being shared that are based on solutions to complex problems.

## Snappy Performance Makes Users Happy

How fast is fast?

* 16ms : 60 fps is **Fast**
* 300ms: is **Snappy**
* 1s+ is like I'm **waiting**
* 10s+ is bad, you just **lost a visitor**

When working with Ember applications remember that the Ember part is a subset of the code that affects Web performance (page speed). A good goal is to provide a snappy response which is under 1 second; about 300 milliseconds. When measuring page speed, the visual performance, how a visitor perceives responsiveness should be considered as well. Recording a video of the page load and marking when the page looks ready is an indicator that should be weighted along other speed measurements like first load time, document ready, etc.

Methodology

1. Gather Facts
1. Analyze and Theorize
1. Change a Single Thing
1. Confirm your Theory

Also when testing it's a good idea to disable browser extensions. "Browser Networking" is a book we should all own and reference. Getting familiar with the browser's development tools for performance is what is needed to analyze and test performance optimizations. The flame chart in a render snapshot can expose problematic cycles of re-rendering and performance sinkholes. Also property change notifications can affect performance. Instead of looping over a collection and inserting or setting properties during each iteration, look for ways to complete enumerations then make an assignment of a collection to an object property.

I think it was mentioned that there should be a book on this topic coming soon. See the speakers post on the talk here: [Performance in Ember Apps](http://madhatted.com/2014/3/28/via-emberconf-performance-in-ember-apps)

## Evolution: The Extensible Web

Open source is awesome! Remember when Netscape pushed it's source code to the Web. That was a Revolution. The JavaScript development lifecycle is still evolving. 

* Focus: don't re-invent the universe
* Consistency: keep unified development model
* Adoption: gradual adoption with polyfills, compilers

One example of evolution is the use of `"use strict";` developers can opt-in. But we know opt-out is better, so ES6 modules are strict by default.

The cycle of evolution is: a) study the text then b) interpret the text, next a) study the text, and b) interpret the text. Repeat A then B until the delta between the two (study/interpret) becomes small enough to ship. As developers we like to move fast and break things. The loop we work in is: build, ship, evaluate, repeat while it's all good. When talking about standards we need to add a step, "don't break the web". So the cycle becomes: build, ship, evaluate, oh, don't break the web then repeat while everything is still good.

The aim of [the Extensible Web](http://extensiblewebmanifesto.org) is to tighten the feedback loop between the editors of web standards and web developers. It's critical for developers to be involved with browser vendors during this cycle. That's why we try new thinks and sometimes there's some breakage until those deltas become closer.

The key story of The Extensible Web is:

* Add missing primitives
* Enable userland polyfills & compilers
* Work together to design the future

One think I noticed about the Ember community was the adoption of ES6 modules. I've seen some breakage in Ember Canary while this shift has been happening. It actually bothered me a bit I was thinking aren't there bigger fish to fry, like data persistence? After this talk I see how these minor growing pains do contribute to the development community as a whole. We've been hungry for modules and they've just about landed in browserland for new we're using a transpiler to AMD but this exercise not only shows browser vendors the value of modules it gives us a chance to put the concepts into flight as the standard is adopted.

## Just Stop

This topic was introduced at the onset of the conference; and I did already touch on it once; I'd like to emphasize the importance of the community. The core team of the Ember community came to an agreement about what rules we should adopt as a development community. 

In practice... if someone says something that offends you, do speak up for yourself by saying "Just stop." Likewise, if a friend says something that you think might offend another friend, we're all friends by the way, in case you didn't know, speak up for your friend by saying "Just stop."

*Simple isn't it.*

Rules were made to be broken right, well we're all human and I think that is the point. We are all capable of saying something we might regret so when we adopt to play by this rule we can help our community flourish and also benefit from the results of a thriving development community that is basically re-inventing the Web platform.

Whether you are a religious Jew, someone who doesn't drink, are born of a minority race, or you belong to any facet that composes a diverse community of people having a varying (even conflicting) set of world views; you can show respect toward others, so can I. *I really like this concept of thinking about others first.* I think that this idea is already engrained within the Ember community. Just think about how much sacrifice has already been poured into the framework that we use; and together iterate and improve upon.

## Post Hoc (After the Buzz Settles)

The Ember community is more than a group of people working on a framework; the community is composed of professionals, hackers, entire families (contributors are leased by their loved ones to the community). We're not born of the same country, same blood or race, not in the same timezone; nor do we have the same native language. But we all write code for the Web platform. We have a common goal to make the Web a better platform and we use Ember.js to do it.

**Ciao, my extended Ember family, talk to you on IRC.** Please do comment on this post if you'd like to share your thoughts.

### Links

Thanks to [Ember Weekly Issue 51](http://us4.campaign-archive1.com/?u=ac25c8565ec37f9299ac75ca0&id=3901835468&e=bc026993ad) for collecting the buzz on EmberConf 2014...

**Other EmberConf 2014 Notes/Summaries**

* [EmberConf picks up where the Rails community left off](http://reefpoints.dockyard.com/2014/03/17/emberconf-picks-ups-where-the-rails-community-left-off.html)
* [EmberConf Notes (markdown), Kurt MacDonald](https://github.com/zurt/notes/blob/master/EmberConf-2014.markdown)
* [EmberConf Notes (sketched), Michael Chan](http://chantastic.io/emberconf2014/)
* [EmberConf Notes (blog), Allison Sheren](http://allisonsherenmcmillan.blogspot.ca/search/label/emberconf%202014)
* [EmberConf 2014, Herman Radtke](http://hermanradtke.com/2014/03/27/emberconf-2014.html)
* [EmberConf Wrap Up by Justin Ball](http://www.justinball.com/2014/03/27/ember-conf-2014-wrap-up/)

**[EmberConf 2014](http://emberconf.com/schedule.html) Presentations**

**Day 1**

* [EmberConf 2014 Keynote - Tom Dale & Yehuda Katz](https://speakerdeck.com/tomdale/emberconf-2014-keynote)
* [Using Ember to Make the Seemingly Impossible Easy - Heyjin Kim & Andre Malan](https://speakerdeck.com/simplereach/using-ember-to-make-the-seemingly-impossible-easy)
* [Contributing to Ember: The Inside Scoop - Robert Jackson](https://speakerdeck.com/rwjblue/contributing-to-ember)
* [Ember Data and the Way Forward - Igor Terzic](http://terzicigor.com/talks/index.html#/)
* [No more grunt watch: Modern build workflows with Broccoli - Jo Liss](http://www.slideshare.net/jo_liss/broccoli-32911567)
* [Animations and Transitions in an Ember App - Edward Faulkner](http://ef4.github.io/ember-animation-demo/#/title-slide)
* [Ember Components Transclude My Directives - John K. Paul](http://johnkpaul.github.io/presentations/emberconf/components-transclude-directives/)
* [Modeling the App Store and iTunes with Ember Data - Jeremy Mack](http://emberconf.com/images/slides/2014_jmack.pdf)
* [HTMLBars: The Next-Generation of Templating in Ember.js - Erik Bryn & Kris Selden](http://talks.erikbryn.com/htmlbars-emberconf/)

**Day 2**

* [The {{x-foo}} in You - Ryan Florence](https://github.com/rpflorence/talk-emberconf-2014)
* [Ember CLI - Stef Penner](http://static.iamstef.net/ember_conf_2014.pdf)
* [Ember is for the Children - DeVaris Brown](https://speakerdeck.com/devarispbrown/ember-is-for-the-children)
* [Mr. Router embraces the Controller - Alex Matchneer](https://speakerdeck.com/machty/emberconf-2014-mr-router-embraces-the-controller-alex-matchneer)
* [Convergent/Divergent - Christopher Meiklejohn](https://speakerdeck.com/cmeiklejohn/divergent)
* [The Unofficial, Official Ember Testing Guide - Eric Berry](https://speakerdeck.com/coderberry/the-unofficial-official-ember-testing-guide)
* [Controlling Route Traversal with Flows - Nathan Hammond](https://www.dropbox.com/s/02peoxevqwjz1bu/Controlling%20Route%20Traversal.pdf)
* [Snappy Means Happy: Performance in Ember Apps - Matthew Beale](http://madhatted.com/2014/3/28/via-emberconf-performance-in-ember-apps)


