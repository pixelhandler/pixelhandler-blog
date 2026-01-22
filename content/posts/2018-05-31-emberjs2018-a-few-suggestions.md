---
title: EmberJS2018 – A Few Suggestions
slug: emberjs2018-a-few-suggestions
published_at: '2018-05-31'
author: pixelhandler
tags:
- Ember.js
meta_description: |-
  This post is a response to:
  - [Ember2018 Roadmap Call for Posts](https://emberjs.com/blog/2018/05/02/ember-2018-roadmap-call-for-posts.html)

  My backstory… I...
---

## Community

At EmberConf 2018 I finally participated in the mentorship program. Back in the early days, I remember how the community was small and it was easy to connect with the developers involved in working on the framework itself. As time has passed, some faces have changed. However, the community has done a great job of reproducing it’s culture of shared opinions and solutions; and has retained it's values of kindness and openness. At the mentorship program event, I saw how this happens. It amazed me as I saw new members of the community show the same camaraderie – it’s contagious!

So for 2018, though Ember makes us productive and happy, it can be easy to pass up participation at local meetups or to become less active on the chat and forums. My hope is that we will continue to hand off the baton of the community values to developers who are new to Ember.

## Marketing

I hope developers building with Ember can make it a point to share *why* they enjoy building with Ember. Instead of sharing only how and what we build. We can tell the story of *why* we build with shared opinions and solutions.

I find that Ember makes me productive and happy. The tools for testing have grown better and better over the years; and the Ember ecosystem proves to help me develop quality and stable software with JavaScript. These shared solutions help me to find common solutions and patterns which have already found success. For example, addons like _ember-concurrency_ and _ember-cli-typescript_ push me to use patterns that others understand, are documented well, and work great. This has been common place in the Ember community for years.

I can keep up with current releases or stick with an LTS version for a time if I need to.

To summarize my message, “Ember in 2018 is not the Ember I remember.” The applications I work on continue to evolve as tooling and shared solutions mature. I can avoid bespoke code yet with addons I can still experiment with new ideas and solutions. I’ve enjoyed implementing features with a unilateral and immutable data flow. I really enjoy being an early adopter of building with TypeScript in Ember applications; as well as using (experimental) decorators. Using classes, decorators, and TypeScript in the applications I develop looks very different from the applications I worked on in 2017. They do feel very modern. At the same time, these tools make it easier for developers, who are less familiar with Ember, to understand the application code.

## Standards

I hope that Custom Elements are first class in Ember, and that Ember components can upgrade a custom element just adding template bindings. It will be amazing when Components as just baked on the Web Components standards.
- [Custom Elements](https://html.spec.whatwg.org/multipage/custom-elements.html#custom-elements)

Regaring _actions_, I know they work fine and are documented well. But, I find as new developers begin working on Ember applications _actions_ are confusing. It seems that "closure actions" (using the `action` keyword in templates) is a goto solution. And, we often pass actions down (since they can talk back). The idea of "data down actions up" has evolved to "data down plus actions down too". I wonder how we can simplify this concept of handing events? I think that perhaps sticking closer to standards may help. I wonder, are we doing too much with _actions_ when we should be authoring events? E.g. using built in events, plus custom events.

## Bugs

I hope more developers can help triage Ember issues. Helping the core teams find a better signal to noise ratio from the Ember issue tracker on github will go a long way with seeing more bugs closed out. _It takes a village_. Simply looking over issues and helping developers reproduce their issue with an working example or even creating a failing test would be awesome.

## Documentation

Ember leaves the model layer up to the needs of the problem domain which developers strive to provide their solution for. Ember data is a great example of how to leverage an ORM and to work with a common API standard, i.e. *JSON API*. And it provides solutions for custom adapters and serializers to fit just about _any_ need. The abstraction is good. However, I have worked on various applications where the data layer did not fit the solutions Ember data provides. I would like to see more solutions as official documentation that use the Fetch API, or a simple XHR solution. Perhaps developers should be encouraged to follow the data patterns in the domain which their applications live in - versus conforming to an abstraction to an ORM solution. For example, using eventual consistency via a CQRS pattern (for persistence) is very different. What about real time data? How about examples using web sockets?

Also, I’d like to see more examples of using domain/business logic in a UI model layer with components which are simple in scope - the components just leverage data and methods of models (instead of implementing domain specific login within components). I think unit test for models run fast - as they do not need to render anything. And for component tests, domain logic can be stubbed in rendering tests for testing component behaviors.

One thing I find, is that business logic can be sprinkled all over an application - a bit in the component, a bit in the route, a bit in the controller, a bit in the model, and a bunch more in the template(s). I think that the Ember framework provides patterns for developing single page apps which are great. Perhaps, we also need some encouragement as a community to model solutions thoroughly and utilize framework objects to connect to our business logic - that is through our UI model objects vs. complex components and service combinations.

I get that Ember provides Service and Component objects which can be leaned on heavily; as well as a default solution for data models (persistence). These are great tools for building applications on.

## Ember.Object

Can we just use `class`, I do. The _ember-cli-typescript_ addon encourages the use of classes and extending `EmberObject`. I think current appliation code should utilize class syntax vs. `EmberObject.exend()`.

## A11y

Good solutions exist for accessibility (A11y) provided through addons. As a commnity I hope we can leverage these and share our success stories more.

## Routing

There are lots of bugs in the issue tracker for routing. I know Ember has gone though various router implementations. But, what if the router was an addon? And, a simple alternate option existed as well? Perhaps a router that just has a function to match the request URI and a function to render. Maybe _ember-simple-router_?

## Code splitting

I am sure everyone is like yeah is there a way to break up the large assets and load modules on demand? Is that solution the ‘engines’ solution? Well, I imagine someone is working on this and I look forward to using it one day :)

## Wrap up

I am so happy be be a part of a JavaScript community which advances standards (e.g. JS modules) and tooling - while keeping me productive and happy. I like that there is room to experiment as well. And, since the framework evolves by learning from the success of other libraries and tools our applications do not grow stale; we can avoid becoming legacy developers (even though that is a sign of some success, maintaining a legacy application that is). Some things I’m interested in, but have not explored with Ember, are using tools like RxJS or other reactive patterns.