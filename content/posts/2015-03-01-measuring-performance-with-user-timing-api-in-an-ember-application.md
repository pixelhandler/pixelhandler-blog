---
title: Measuring Performance with User Timing API, in an Ember Application
slug: measuring-performance-with-user-timing-api-in-an-ember-application
published_at: '2015-03-01'
author: pixelhandler
tags:
- Ember.js
- Performance
meta_description: As the release of [Ember.js] v1.10.0 approached, I became curious
  about how to measure the speed of rendering templates in an Ember application. I
  wanted to ...
---

For more info on Handlebars and HTMLbars see:
* [Compiling Templates in Ember v1.10.0]
* [Feature-by-Feature Review]

[Compiling Templates in Ember v1.10.0]: http://emberjs.com/blog/2015/02/05/compiling-templates-in-1-10-0.html
[Feature-by-Feature Review]: http://colintoh.com/blog/htmlbars "HTMLBars - A Feature-by-Feature Review"

## Using the renderTemplate hook to mark, measure and report metrics

In an Ember application, there are various hooks between [routing] a request and drawing HTML on the DOM. The [renderTemplate] hook is the most desireable hook to utilize for marking, measuring and reporting the performance metrics captured while presenting HTML to users. The `renderTemplate` hook is called after the `model` hooks and `setupController` hook compose your data for your template bindings. Combined with the [run-loop], specifically the [schedule] for `afterRender` the `renderTemplate` hook can mark the *beginning* of the work to render a template and, in the `afterRender` queue, mark the *completion* of the work. (`Ember.run.queues` lists the queues that are scheduled by the run loop: `["sync", "actions", "routerTransitions", "render", "afterRender", "destroy"]`)

[routing]: http://emberjs.com/guides/routing/
[renderTemplate]: http://emberjs.com/api/classes/Ember.Route.html#method_renderTemplate
[run-loop]: http://emberjs.com/guides/understanding-ember/run-loop/
[schedule]: http://emberjs.com/api/classes/Ember.run.html#method_schedule

## Mark, Measure and Report User Timing Metrics

I created a utility with an interface to [mark][performancemark], [measure][performancemeasure] and report measurements taken with the [User Timing] API. I did use a polyfill for browsers that do not implement the [performance] specifications.

[User Timing]: http://www.w3.org/TR/user-timing
[performancemark]: http://www.w3.org/TR/user-timing/#performancemark
[performancemeasure]: http://www.w3.org/TR/user-timing/#performancemeasure
[performance]: http://www.w3.org/standards/techs/performance#w3c_all

I used the mixin below in various routes, e.g. Index, Application, Post etc. to collect and measure the statistics for reporting on the timings that an Ember application renders HTML.

    import Ember from 'ember';
    import config from '../config/environment';
    import { mark, measure, report } from '../utils/metrics';

    export default Ember.Mixin.create({

      measurementName: Ember.required,

      reportUserTimings: true,

      renderTemplate(controller, model) {
        var beginName = 'mark_begin_rendering_' + this.measurementName;
        var endName = 'mark_end_rendering_' + this.measurementName;
        if (config.APP.REPORT_METRICS) {
          mark(beginName);
          Ember.run.scheduleOnce('afterRender', this, function() {
            mark(endName);
            measure(this.measurementName, beginName, endName);
            if (this.reportUserTimings) {
              report();
            }
          });
        }
        return this._super(controller, model);
      }

    });

## Utility Module for Metrics Collection and Reporting

This mixin wraps the `window.performance` methods and provides functions for reporting the measurements using an XHR request and [Google Analytics to report User Timings].

What is amazing about the performance measurements is that the API uses high-resolution timing with sub-millisecond resolution.

[Google Analytics to report User Timings]: https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings


    /*jshint unused:false*/
    import Ember from 'ember';
    import config from '../config/environment';

    export function mark(name) {
      if (!window.performance || !window.performance.mark ) { return; }
      window.performance.mark(name);
    }

    export function measure(name, begin, end) {
      if (!window.performance || !window.performance.measure ) { return; }
      window.performance.measure(name, begin, end);
    }

    export function appReady() {
      return measureEntry('app_ready');
    }

    export function appUnload() {
      return measureEntry('app_unload');
    }

    export function pageView() {
      return measureEntry('page_view');
    }

    function measureEntry(name) {
      if (!window.performance || !window.performance.getEntriesByName ) { return; }
      var markName = name + '_now';
      mark(markName);
      if (window.performance.timing) {
        measure(name, 'navigationStart', markName);
      } else {
        measure(name, markName, markName);
      }
    }

    export function report() {
      if (!window.performance || !window.performance.getEntriesByType ) { return; }
      window.setTimeout(function() {
        send(window.performance.getEntriesByType('measure'));
        clear();
      }, 1000);
    }

    function send(measurements) {
      var measurement;
      for (var i = 0; i < measurements.length; ++i) {
        measurement = measurements[i];
        post(measurement);
        gaTrackTiming(measurement);
      }
    }

    export function post(measurement) {
      var payload = createMetric(measurement);
      return Ember.$.ajax({
        type: 'POST',
        url: endpointUri('metrics'),
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ metrics: payload }),
        dataType: 'json'
      });
    }

    function gaTrackTiming(measurement) {
      if (typeof window.ga !== 'function') { return; }
      window.ga('send', {
        'hitType': 'timing',
        'timingCategory': 'user_timing',
        'timingVar': measurement.name,
        'timingValue': measurement.duration,
        'timingLabel': measurement.emberVersion,
        'page': measurement.pathname
      });
    }

    function createMetric(measurement) {
      return {
        date: Date.now(),
        name: measurement.name,
        pathname: location.pathname,
        startTime: Math.round(measurement.startTime),
        duration: Number(Math.round(measurement.duration + 'e3') + 'e-3'), // round to thousandths
        visitor: window.localStorage.getItem('visitor'),
        screenWidth: window.screen.width,
        screenHeight: window.screen.height,
        screenColorDepth: window.screen.colorDepth,
        screenPixelDepth: window.screen.pixelDepth,
        screenOrientation: (window.screen.orientation) ? window.screen.orientation.type : null,
        blogVersion: config.APP.version,
        emberVersion: Ember.VERSION,
        adapterType: (config.APP.USE_SOCKET_ADAPTER) ? 'SOCKET' : 'JSONAPI'
      };
    }

    function endpointUri(resource) {
      var host = config.APP.API_HOST;
      var path = config.APP.API_PATH;
      var uri = (path) ? host + '/' + path : host;
      return uri + '/' + resource;
    }

    function clear() {
      window.performance.clearMarks();
      window.performance.clearMeasures();
    }

### Learn more about User Timing API to Measure Performance

* [W3C Web Performance](http://www.w3.org/TR/#tr_Web_Performance)
* [Performance Mark Method](http://www.w3.org/TR/user-timing/#dom-performance-mark)
* [Performance Measure Method](http://www.w3.org/TR/user-timing/#dom-performance-measure)
* [HTML5Rocks: User Timing API](http://www.html5rocks.com/en/tutorials/webperformance/usertiming/)
* [Caniuse Performance](http://caniuse.com/#search=performance)
* [High Resolution Time](http://www.w3.org/TR/hr-time/)

## Reporting the metrics

At first I decided to add a */metrics* endpoint to my API, then later realized that Google Analytics can collect and report on User Timing measurements as well (I'm using both). I prefer the data in my own database, I can create very specific queries to search the userAgent string to compare measurements for mobile, iPad, iPhone, etc.

In addition to collecting measurements for rendering templates I collected metrics on finding data (via an adapter). The metrics I report on are named `app_ready`, `application_view`, `index_view`, `post_view`, `page_view`, `app_unload`, `archive_view`, and `find_posts`.

*An Example Metric Resource:*

    {
      adapterType: 'SOCKET',
      blogVersion: '3.3.8.fa3fbaf8',
      date: '2015-02-08T06:29:17.368Z',
      duration: 113.35,
      emberVersion: '1.10.0',
      id: '1a9864a2-4011-49d8-9233-fa76d26e9040',
      name: 'post_view',
      pathname: '/posts/refreshed-my-blog-with-express-and-emberjs',
      screenColorDepth: 24,
      screenHeight: 900,
      screenOrientation: 'landscape-primary',
      screenPixelDepth: 24,
      screenWidth: 1440,
      startTime: 391,
      userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) .... Safari/537.36',
      visit: '22d5d2b0be4067ac3af57f4b14fcbb4b4d89fe34b1eeeaab910c259e7b9c55aa',
      visitor: 'c56f439e-646b-4f6a-b91b-5c119e21efba'
    }

I created endpoints on my API for */metrics/impressions* and */metrics/durations* that accept queries that use regular expression matching to search for data based on the object properties of the metrics. For example I can search the pathname, userAgent and emberVersion when reporting on the metrics data.

More info on these endpoints:

* [discuss.emberjs : Collecting performance metrics]
* [Metrics API Endpoints]

[Metrics API Endpoints]: https://github.com/pixelhandler/blog/tree/master/server#metrics-api-endpoints
[discuss.emberjs : Collecting performance metrics]: http://discuss.emberjs.com/t/collecting-performance-metrics-using-rendertemplate-hook-and-user-timing-api/7270/1 "Collecting performance metrics using renderTemplate hook and User Timing API"

## Metrics: Rendering with HTMLBars vs Handlebars

I consider the fact that the user only needs a single full screen at a time. So my app loads records in chunks when the user scrolls to the end. I'm not as interested in how well a large table of a thousand records performs; I don't think that users will enjoy waiting for the data anyway. But, for those interested in that kind of pain… I created a page on my site that has 1,000 metrics records, a long list. I collect metrics on rendering that metrics table as well. I'm not convinced that this metric really matters to users. Maybe, if I had a complex data visualization that had a 1,000 data points it would matter. Well, then I'd likely use a data vizualization library (like D3) to render the data instead. So, I'm not convinced that rendering a long list is really of any value to any user. Whether that (long list) measurement is relevant as metric for comparing a template library, my vote is thumbs down.

I am convinced that measuring the perceived performance of web application matters to my users. I think that with these measurements, I can identify trends and make some informed assumptions about how these metrics apply to other Ember applications I work on.

Below are some measurements I took, I gave about a week of web traffic to both template library solutions. I measured the timings for rendering views in my app running both a) Ember.js v1.8.1 with Handlebars v1.3 and b) Ember v1.10.0 and HTMLBars (the initial release).

I was able to collect a good sized data set, so that the average (speed) durations are good comparison between various facets of the metrics data, e.g. emberVersion and userAgent. I can report on the average of all user agents, or on a specfic type of userAgent. Since the timings are measured after data is fetched and the application is ready, I am confident that the metrics captured do reflect the timings that actual users experience.

### A few comparisons (Ember.js v1.10.0 and v1.8.1)

The measurements below highlight some gains and losses as a result of the upgrade from Handlebars to HTMLbars in my application…

#### All userAgents, desktop and mobile

Index (home) page in v1.8.1  

    //Ember v1.8.1
    {
      average: 154.41764912280703,
      durations: 114,
      fastest: 5,
      pathname: "/",
      slowest: 914
    }

Index (home) page in v1.10.0  

    // Ember v1.10.0
    {
      average: 244.7352818181818,
      durations: 220,
      fastest: 5,
      pathname: "/",
      slowest: 1854.635
    }

The most visited (post) page in v1.8.1

/metrics/durations?name=post_view&pathname=mongoose&emberVersion=1.8

    // Ember v1.8.1
    {
      average: 251.42101618705053,
      durations: 1668,
      fastest: 8,
      pathname: "/posts/develop-a-restful-api-using-nodejs-with-express-and-mongoose",
      slowest: 3696
    }

The most visited (post) page in v1.10.0

/metrics/durations?name=post_view&pathname=mongoose&emberVersion=1.10

    // Ember v1.10.0
    {
      average: 232.02967880485514,
      durations: 2142,
      fastest: 8,
      pathname: "/posts/develop-a-restful-api-using-nodejs-with-express-and-mongoose",
      slowest: 5726
    }

Long list (1,000 metrics) in v1.10.0, in Chrome

/api/metrics/durations?name=metrics_table&emberVersion=1.10&userAgent=Chrome

    // Ember Version 1.10.0
    {
      average: 690.5488399999999,
      durations: 25,
      fastest: 427.563,
      pathname: "/metrics",
      slowest: 1142.15
    }

Long list (1,000 metrics) in v1.8.1, in Chrome

/metrics/durations?name=metrics_table&emberVersion=1.8&userAgent=Chrome

    // Ember Version 1.8.1
    {
      average: 682.4195625,
      durations: 16,
      fastest: 457.012,
      pathname: "/metrics",
      slowest: 991.684
    }

#### On Mobile

Index (home) page in v1.10.0, on Mobile

/metrics/durations?name=index_view&emberVersion=1.10&userAgent=Mobile

    // Ember Version 1.10.0
    {
      average: 580.4696976744186,
      durations: 43,
      fastest: 160,
      pathname: "/",
      slowest: 1490
    }

Index (home) page in v1.8.1, on Mobile

/metrics/durations?name=index_view&emberVersion=1.8&userAgent=Mobile

    // Ember Version 1.8.1
    {
      average: 515.881875,
      durations: 8,
      fastest: 330,
      pathname: "/",
      slowest: 914
    }

Long list (1,000 metrics) in v1.8.1, on Mobile

/metrics/durations?name=metrics_table&emberVersion=1.8&userAgent=Mobile

    // Ember Version 1.8.1
    {
      average: 2179.4,
      durations: 10,
      fastest: 871,
      pathname: "/metrics",
      slowest: 5380
    }

Long list (1,000 metrics) in v1.10.0, on Mobile

/metrics/durations?name=metrics_table&emberVersion=1.10&userAgent=Mobile

    // Ember Version 1.10.0
    {
      average: 1617.4285714285713,
      durations: 7,
      fastest: 1014,
      pathname: "/metrics",
      slowest: 2285
    }

## What I learned about my Performance in my Ember app

I have not read "How not to lie with statistics, The correct way to summarize benchmark results". So, the measurements I've taken at this point, are only an exploration of a data set that is not normalized.

From jayconrod.com… "The geometric mean is intended for averaging ratios (normalized data)" … "Don't bother summarizing raw data without normalizing it."

So, I can't make any conclusions at this point, I can only ask more questions. For example, how do I normalize the data I've that I've captured and calculate the geometric means?

**UPDATE: 3/8/15** I've calculated my findings in a new post: [How Much Faster is HTMLBars Than Handlebars?](/posts/how-much-faster-is-htmlbars-than-handlebars)

*Regarding the upgrade from Handlebars to HTMLbars…*

* Looking at the average speed of rendering the home page did not seem to show a performance gain, but the data set is not normalized
* The same can be said for the speed of rendering the templates on my post pages
* Though I don't believe that rendering a long list doesn't matter to my users, after experimenting with a long list I did notice notice any big gains in performance looking at the fastest rendering times in the data I collected

However what appears to be good news, is that the fastest speeds did improve, and even more so on mobile.

*On Mobile…*

It appears that…

* I may expect a 25% - 50% gain in performance for the fastest time to render.
*The performance gains my users will benefit from (after the upgrade) are limited to the users who have newer mobile devices*

Thanks to the hard work of the Ember.js contributors and core team its my expectation that users browsing my site should see a boost in performance. 

Since I found these measurements valuable, I'll continue to collect them and review as I try out various beta versions of Ember.js. Recently another release of the 1.11.0 series was released, so I'll give it a try soon.

_Once I discover how to normalize the metrics and calculate a proper geometric mean then I can draw some more definitive summaries about the measurements._

At this point, I am very satisfied to have these metrics available from a production build, on a production server from a wide set of users, I get around 10,000 unique users and 30,000 pageviews per month on my blog app. This is not huge, but does provide some good insight into trends I can expect from previous, current and future releases of Ember.

I gave a talk on this topic, here are [my presentation notes](https://gist.github.com/pixelhandler/f01a1703721d31de0de1) 
