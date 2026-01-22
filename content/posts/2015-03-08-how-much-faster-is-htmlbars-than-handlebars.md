---
title: How Much Faster is HTMLBars Than Handlebars?
slug: how-much-faster-is-htmlbars-than-handlebars
published_at: '2015-03-08'
author: pixelhandler
tags:
- Ember.js
- Templates
meta_description: Last week I posted an article about [Measuring Performance with
  User Timing API, in an Ember Application](/posts/measuring-performance-with-user-timing-api-i...
---

When I shared the data with Kris Seldon, he asked whether I had normalized the data and calculated the geometric mean, since that would be a proper way to compare benchmarks. I found the document [How not to lie with statistics, The correct way to summarize benchmark results](http://ece.uprm.edu/~nayda/Courses/Icom5047F06/Papers/paper4.pdf) by Philip J. Fleming and John J. Wallace. So, I wrote a query for my data set that would group the metrics data in an effort to normalize the measurements taken from actual users on various devices and group the measurements into the benchmarks that I could generate some reporting data from.
To itentify the benchmarks I could report on I wrote some filters for the various userAgent strings within my metrics data. I considered the combination of the operating system and the browser, e.g. Safari on Macintosh, or iPad combined with a type of metric, e.g. `index_view`. Then I compared the Ember versions.

With the normalized set of data, I created a query that would take the latest measurements, up to 100, from the normalized data set and calculated the geopmentric mean for the various benchmarks. I calculated the product of each duration in the normalize set; then raised that value by an exponent that is the reciprocal of the number of factors in that product. (Geometric Mean: multiply the numbers and then take the nth root of the product.) The calculation looked something like this `Math.round(Math.pow(2 * 3 * 5 * 8 * 13 * 21, 1/6) * 1000) / 1000` (I rounded to the nearest thousandth). As for the normalization of the data, the metrics can be reported by the Ember Version, platform (Macintosh/Windows) and browser (Chrome, Safari, Firefox, iPad, iPhone, Android) for the specific metric type, e.g. `index_view`, `post_view` or the `metric_table` (for the long list of 1,000 items).

*I'd like to share my measurements and calculations…*

## Performance Report

For the upgrade on my site to HTMLBars from Handlebars 1.3…

**Across the board, for the benchmarks I am intersted in, it looks like HTMLBars brought a 10-22% gain in rendering speeds**

<table>
		<caption>
				Index View: Home Page
		</caption>
		<thead>
				<tr>
						<th>
								Platform
						</th>
						<th>
								Browser
						</th>
						<th class="not-for-small-screen">
								v1.8 Mean
						</th>
						<th class="not-for-small-screen">
								v1.10 Mean
						</th>
						<th class="not-for-small-screen">
								Difference
						</th>
						<th>
								Gain/Loss %
						</th>
				</tr>
		</thead>
		<tbody>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Safari
						</td>
						<td class="not-for-small-screen">
								162.343
						</td>
						<td class="not-for-small-screen">
								86.653
						</td>
						<td class="not-for-small-screen">
								75.69
						</td>
						<td>
								47%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								183.794
						</td>
						<td class="not-for-small-screen">
								187.945
						</td>
						<td class="not-for-small-screen">
								-4.151
						</td>
						<td>
								-2%
						</td>
				</tr>
				<tr>
						<td>
								Windows
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								136.289
						</td>
						<td class="not-for-small-screen">
								211.616
						</td>
						<td class="not-for-small-screen">
								-75.327
						</td>
						<td>
								-55%
						</td>
				</tr>
				<tr>
						<td>
								iOS
						</td>
						<td>
								iPhone
						</td>
						<td class="not-for-small-screen">
								450.503
						</td>
						<td class="not-for-small-screen">
								352.764
						</td>
						<td class="not-for-small-screen">
								97.739
						</td>
						<td>
								22%
						</td>
				</tr>
		</tbody>
		<tfoot>
				<tr>
						<td colspan='2'>Overall</td>
						<td class="not-for-small-screen">
								206.89
						</td>
						<td class="not-for-small-screen">
								186.73
						</td>
						<td class="not-for-small-screen">
								20.16
						</td>
						<td>
								10%
						</td>
				</tr>
		</tfoot>
</table>

<br><br>

<table>
		<caption>
				Post View: Article Pages
		</caption>
		<thead>
				<tr>
						<th>
								Platform
						</th>
						<th>
								Browser
						</th>
						<th class="not-for-small-screen">
								v1.8 Mean
						</th>
						<th class="not-for-small-screen">
								v1.10 Mean
						</th>
						<th class="not-for-small-screen">
								Difference
						</th>
						<th>
								Gain/Loss %
						</th>
				</tr>
		</thead>
		<tbody>
				<tr>
						<td>
								iOS
						</td>
						<td>
								iPad
						</td>
						<td class="not-for-small-screen">
								801.595
						</td>
						<td class="not-for-small-screen">
								375.945
						</td>
						<td class="not-for-small-screen">
								425.65
						</td>
						<td>
								53%
						</td>
				</tr>
				<tr>
						<td>
								iOS
						</td>
						<td>
								iPhone
						</td>
						<td class="not-for-small-screen">
								348.711
						</td>
						<td class="not-for-small-screen">
								302.05
						</td>
						<td class="not-for-small-screen">
								46.661
						</td>
						<td>
								13%
						</td>
				</tr>
				<tr>
						<td>
								Android
						</td>
						<td>
								Various
						</td>
						<td class="not-for-small-screen">
								850.716
						</td>
						<td class="not-for-small-screen">
								862.627
						</td>
						<td class="not-for-small-screen">
								-11.911
						</td>
						<td>
								-1%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Safari
						</td>
						<td class="not-for-small-screen">
								109.321
						</td>
						<td class="not-for-small-screen">
								117.684
						</td>
						<td class="not-for-small-screen">
								-8.363
						</td>
						<td>
								-8%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								145.244
						</td>
						<td class="not-for-small-screen">
								163.481
						</td>
						<td class="not-for-small-screen">
								-18.237
						</td>
						<td>
								-13%
						</td>
				</tr>
				<tr>
						<td>
								Windows
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								203.063
						</td>
						<td class="not-for-small-screen">
								232.081
						</td>
						<td class="not-for-small-screen">
								-29.018
						</td>
						<td>
								-14%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Firefox
						</td>
						<td class="not-for-small-screen">
								147.432
						</td>
						<td class="not-for-small-screen">
								140.634
						</td>
						<td class="not-for-small-screen">
								6.798
						</td>
						<td>
								5%
						</td>
				</tr>
				<tr>
						<td>
								Windows
						</td>
						<td>
								Firefox
						</td>
						<td class="not-for-small-screen">
								200.542
						</td>
						<td class="not-for-small-screen">
								163.704
						</td>
						<td class="not-for-small-screen">
								36.838
						</td>
						<td>
								18%
						</td>
				</tr>
		</tbody>
		<tfoot>
				<tr>
						<td colspan='2'>Overall</td>
						<td class="not-for-small-screen">
								262.68
						</td>
						<td class="not-for-small-screen">
								237.34
						</td>
						<td class="not-for-small-screen">
								25.34
						</td>
						<td>
								10%
						</td>
				</tr>
		</tfoot>
</table>

<br><br>

<table>
		<caption>
				Metrics Table: Long List of 1,000 Records
		</caption>
		<thead>
				<tr>
						<th>
								Platform
						</th>
						<th>
								Browser
						</th>
						<th class="not-for-small-screen">
								v1.8 Mean
						</th>
						<th class="not-for-small-screen">
								v1.10 Mean
						</th>
						<th class="not-for-small-screen">
								Difference
						</th>
						<th>
								Gain/Loss %
						</th>
				</tr>
		</thead>
		<tbody>
				<tr>
						<td>
								iOS
						</td>
						<td>
								iPad
						</td>
						<td class="not-for-small-screen">
								3323.655
						</td>
						<td class="not-for-small-screen">
								2170.638
						</td>
						<td class="not-for-small-screen">
								1153.017
						</td>
						<td>
								35%
						</td>
				</tr>
				<tr>
						<td>
								iOS
						</td>
						<td>
								iPhone
						</td>
						<td class="not-for-small-screen">
								1580.537
						</td>
						<td class="not-for-small-screen">
								1268.771
						</td>
						<td class="not-for-small-screen">
								311.766
						</td>
						<td>
								20%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Safari
						</td>
						<td class="not-for-small-screen">
								448.611
						</td>
						<td class="not-for-small-screen">
								302.707
						</td>
						<td class="not-for-small-screen">
								145.904
						</td>
						<td>
								33%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								903.33
						</td>
						<td class="not-for-small-screen">
								646.06
						</td>
						<td class="not-for-small-screen">
								257.27
						</td>
						<td>
								28%
						</td>
				</tr>
				<tr>
						<td>
								Windows
						</td>
						<td>
								Chrome
						</td>
						<td class="not-for-small-screen">
								812.356
						</td>
						<td class="not-for-small-screen">
								829.604
						</td>
						<td class="not-for-small-screen">
								-17.248
						</td>
						<td>
								-2%
						</td>
				</tr>
				<tr>
						<td>
								Macintosh
						</td>
						<td>
								Firefox
						</td>
						<td class="not-for-small-screen">
								865.249
						</td>
						<td class="not-for-small-screen">
								743.429
						</td>
						<td class="not-for-small-screen">
								121.82
						</td>
						<td>
								14%
						</td>
				</tr>
		</tbody>
		<tfoot>
				<tr>
						<td colspan='2'>Overall</td>
						<td class="not-for-small-screen">
								1069.48
						</td>
						<td class="not-for-small-screen">
								832.20
						</td>
						<td class="not-for-small-screen">
								237.27
						</td>
						<td>
								22%
						</td>
				</tr>
		</tfoot>
</table>

<br>

[excel_to_html_table/]: http://pressbin.com/tools/excel_to_html_table/index.html


## The Details

Below is a look at the calculations for each of the benchmarks that I included in the summary above.

### The Index (Home) Page

#### Safari on Macintosh

*HTMLbars shaved of 76 milliseconds, a 46% gain in rendering speed*

    {
      fast: 32.94,
      geometric_mean: 86.653,
      measurments: 100,
      name: "index_view",
      slow: 819,
      emberVersion: "1.10",
      platform: "Macintosh",
      browser: "Safari"
    }

    {
      fast: 105.18,
      geometric_mean: 162.343,
      measurments: 4,
      name: "index_view",
      slow: 244.669,
      emberVersion: "1.8",
      platform: "Macintosh",
      browser: "Safari"
    }

#### Chrome on Macintosh

*Only a 4 millisecond difference, a 2% decrease in rendering speed*

	{
	  fast: 65.41,
	  geometric_mean: 187.945,
	  measurments: 100,
	  name: "index_view",
	  slow: 9547.233,
	  emberVersion: "1.10",
	  platform: "Macintosh",
	  browser: "Chrome"
	}

	{
	  fast: 90.804,
	  geometric_mean: 183.794,
	  measurments: 70,
	  name: "index_view",
	  slow: 550.173,
	  emberVersion: "1.8",
	  platform: "Macintosh",
	  browser: "Chrome"
	}

#### Chrome on Windows

*Handlebars 1.3 was 74 milliseconds faster, a 35% gain in rendering speed*

	{
	  fast: 81.023,
	  geometric_mean: 211.616,
	  measurments: 100,
	  name: "index_view",
	  slow: 1397,
	  emberVersion: "1.10",
	  platform: "Windows",
	  browser: "Chrome"
	}

	{
	  fast: 95.374,
	  geometric_mean: 136.289,
	  measurments: 13,
	  name: "index_view",
	  slow: 172.329,
	  emberVersion: "1.8",
	  platform: "Windows",
	  browser: "Chrome"
	}

#### Android

*Only had measurements on Ember v1.10.0*

	{
	  fast: 520.524,
	  geometric_mean: 841.979,
	  measurments: 18,
	  name: "index_view",
	  slow: 1382.816,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "Android"
	}

#### iPad

*Only had measurements on Ember v1.10.0*

	{
	  fast: 155,
	  geometric_mean: 484.614,
	  measurments: 34,
	  name: "index_view",
	  slow: 1120,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPad"
	}

#### iPhone

*HTMLBars shaved off 98 milliseconds, a 22% gain in rendering speed*

	{
	  fast: 143,
	  geometric_mean: 352.764,
	  measurments: 62,
	  name: "index_view",
	  slow: 1490,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPhone"
	}

	{
	  fast: 330,
	  geometric_mean: 450.503,
	  measurments: 7,
	  name: "index_view",
	  slow: 588,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "iPhone"
	}

So for the index page the gains from HTMLBars I noticed were on Safari on Macintosh and on the iPhone. However using Chrome on Windows Handlebars was faster.

I didn't have lots of data for the home page in Ember v1.8.1 but did get loads of traffic on some of my posts, let's see how the individual posts pages did.

### Post (Article) Pages

#### iPad

*HTMLBars shaved off about 426 milliseconds, a 53% gain in rendering speed*

	{
	  fast: 116,
	  geometric_mean: 375.945,
	  measurments: 100,
	  name: "post_view",
	  slow: 2051,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPad"
	}

	{
	  fast: 193,
	  geometric_mean: 801.595,
	  measurments: 18,
	  name: "post_view",
	  slow: 1449,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "iPad"
	}

#### iPhone

*HTMLBars shaved off about 47 milliseconds, an 11% gain in rendering speed*

	{
	  fast: 8,
	  geometric_mean: 302.05,
	  measurments: 100,
	  name: "post_view",
	  slow: 2139,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPhone"
	}

	{
	  fast: 174,
	  geometric_mean: 348.711,
	  measurments: 32,
	  name: "post_view",
	  slow: 985,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "iPhone"
	}

#### Android

*Handlebars 1.3 was 12 milliseconds faster, no rendering speed gains from upgrade to HTMLBars*

	{
	  fast: 204.868,
	  geometric_mean: 862.627,
	  measurments: 100,
	  name: "post_view",
	  slow: 4610.199,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "Android"
	}

	{
	  fast: 275.503,
	  geometric_mean: 850.716,
	  measurments: 74,
	  name: "post_view",
	  slow: 2747.738,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "Android"
	}

#### Safari on Macintosh

*Handlebars 1.3 was 8 milliseconds faster, no rendering speed gains from upgrade to HTMLBars*

	{
	  fast: 20.164,
	  geometric_mean: 117.684,
	  measurments: 100,
	  name: "post_view",
	  slow: 5616.18,
	  emberVersion: "1.10",
	  platform: "Macintosh",
	  browser: "Safari"
	}

	{
	  fast: 50.377,
	  geometric_mean: 109.321,
	  measurments: 100,
	  name: "post_view",
	  slow: 2551.46,
	  emberVersion: "1.8",
	  platform: "Macintosh",
	  browser: "Safari"
	}

#### Chrome on Macintosh

*Handlebars 1.3 was 18 milliseconds faster, no rendering speed gains from upgrade to HTMLBars*

	{
	  fast: 19.82,
	  geometric_mean: 163.481,
	  measurments: 100,
	  name: "post_view",
	  slow: 4220.102,
	  emberVersion: "1.10",
	  platform: "Macintosh",
	  browser: "Chrome"
	}

	{
	  fast: 18.673,
	  geometric_mean: 145.244,
	  measurments: 100,
	  name: "post_view",
	  slow: 2884.554,
	  emberVersion: "1.8",
	  platform: "Macintosh",
	  browser: "Chrome"
	}

#### Chrome on Windows

*Handlebars 1.3 was 29 milliseconds faster, no rendering speed gains from upgrade to HTMLBars*

	{
	  fast: 31.697,
	  geometric_mean: 232.081,
	  measurments: 100,
	  name: "post_view",
	  slow: 13214,
	  emberVersion: "1.10",
	  platform: "Windows",
	  browser: "Chrome"
	}

	{
	  fast: 56.472,
	  geometric_mean: 203.063,
	  measurments: 100,
	  name: "post_view",
	  slow: 3696,
	  emberVersion: "1.8",
	  platform: "Windows",
	  browser: "Chrome"
	}

#### Firefox on Macintosh

*HTMLBars was 7 milliseconds faster, only a minor gain in rendering speed*

	{
	  fast: 45.745,
	  geometric_mean: 140.634,
	  measurments: 100,
	  name: "post_view",
	  slow: 1247.685,
	  emberVersion: "1.10",
	  platform: "Macintosh",
	  browser: "Firefox"
	}

	{
	  fast: 71.173,
	  geometric_mean: 147.432,
	  measurments: 62,
	  name: "post_view",
	  slow: 387.791,
	  emberVersion: "1.8",
	  platform: "Macintosh",
	  browser: "Firefox"
	}

#### Firefox on Windows

*HTMLBars was 37 milliseconds faster, an 18% gain in rendering speed*

	{
	  fast: 73.865,
	  geometric_mean: 163.704,
	  measurments: 100,
	  name: "post_view",
	  slow: 1860,
	  emberVersion: "1.10",
	  platform: "Windows",
	  browser: "Firefox"
	}

	{
	  fast: 69.896,
	  geometric_mean: 200.542,
	  measurments: 100,
	  name: "post_view",
	  slow: 1305.268,
	  emberVersion: "1.8",
	  platform: "Windows",
	  browser: "Firefox"
	}

### Metrics Table (long list of 1,000 records)

#### iPad

I only had a couple measurments…

*Looks like HTMLBars can be 1153 milliseconds faster, a 35% gain in rendering speed*

	{
	  fast: 2062,
	  geometric_mean: 2170.638,
	  measurments: 2,
	  name: "metrics_table",
	  slow: 2285,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPad"
	}

	{
	  fast: 3103,
	  geometric_mean: 3323.655,
	  measurments: 2,
	  name: "metrics_table",
	  slow: 3560,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "iPad"
	}

#### iPhone

*HTMLBars was 312 milliseconds faster, a 20% gain in rendering speed*

	{
	  fast: 675,
	  geometric_mean: 1268.771,
	  measurments: 8,
	  name: "metrics_table",
	  slow: 1568,
	  emberVersion: "1.10",
	  platform: null,
	  browser: "iPhone"
	}

	{
	  fast: 871,
	  geometric_mean: 1580.537,
	  measurments: 8,
	  name: "metrics_table",
	  slow: 5380,
	  emberVersion: "1.8",
	  platform: null,
	  browser: "iPhone"
	}

#### Safari on Macintosh

*HTMLBars was 146 milliseconds faster, a 48% gain in rendering speed*

    {
      fast: 239.835,
      geometric_mean: 302.707,
      measurments: 13,
      name: "metrics_table",
      slow: 416.321,
      emberVersion: "1.10",
      platform: "Macintosh",
      browser: "Safari"
    }

    {
      fast: 287,
      geometric_mean: 448.611,
      measurments: 6,
      name: "metrics_table",
      slow: 568.253,
      emberVersion: "1.8",
      platform: "Macintosh",
      browser: "Safari"
    }

#### Chrome on Macintosh

*HTMLBars was 257 milliseconds faster, a 28% gain in rendering speed*

    {
      fast: 414.107,
      geometric_mean: 646.06,
      measurments: 27,
      name: "metrics_table",
      slow: 1584.423,
      emberVersion: "1.10",
      platform: "Macintosh",
      browser: "Chrome"
    }

    {
      fast: 457.012,
      geometric_mean: 903.33,
      measurments: 27,
      name: "metrics_table",
      slow: 1564.946,
      emberVersion: "1.8",
      platform: "Macintosh",
      browser: "Chrome"
    }

#### Chrome on Windows

*Handlebars 1.3 was 17 milliseconds faster, a 2% decrease in rendering speed*

    {
      fast: 615.905,
      geometric_mean: 829.604,
      measurments: 3,
      name: "metrics_table",
      slow: 1142.15,
      emberVersion: "1.10",
      platform: "Windows",
      browser: "Chrome"
    }

    {
      fast: 765.64,
      geometric_mean: 812.356,
      measurments: 2,
      name: "metrics_table",
      slow: 861.923,
      emberVersion: "1.8",
      platform: "Windows",
      browser: "Chrome"
    }

#### Firefox on Windows

I did not collect enough measurements to make a comparison

#### Firefox on Macintosh

The data is limited to 2 and 4 measurements, I've incluced the metrics, and unique userAgents to show the individual measuremnts within the normalized set, for example the Firefox versions include versions 33.0 and 37.0.

*In this limited set, HTMLBars is 122 milliseconds faster, a 14% gain in rendering speed*

    {
      "durations": [
        696.713,
        903.421,
        660.65,
        734.586
      ],
      "fast": 660.65,
      "geometric_mean": 743.429,
      "measurments": 4,
      "metrics": [
        {
          "date": "2015-02-17T06:04:15.251Z",
          "duration": 696.713,
          "emberVersion": "1.10.0",
          "id": "8b6994ee-268b-43ce-8f26-96ddfcf466a7",
          "pathname": "/metrics"
        },
        {
          "date": "2015-02-17T06:04:06.243Z",
          "duration": 903.421,
          "emberVersion": "1.10.0",
          "id": "28bad254-c3b9-462e-9966-4bc2fcc8fc63",
          "pathname": "/metrics"
        },
        {
          "date": "2015-02-17T06:02:24.487Z",
          "duration": 660.65,
          "emberVersion": "1.10.0",
          "id": "11dfee70-d635-41fd-8e69-2df4f1c70dc1",
          "pathname": "/metrics"
        },
        {
          "date": "2015-02-17T06:02:24.021Z",
          "duration": 734.586,
          "emberVersion": "1.10.0",
          "id": "b58722d9-c9eb-4ab2-bac7-41ba187a3646",
          "pathname": "/metrics"
        }
      ],
      "name": "metrics_table",
      "slow": 903.421,
      "userAgents": [
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:33.0) Gecko/20100101 Firefox/33.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0"
      ],
      "emberVersion": "1.10",
      "platform": "Macintosh",
      "browser": "Firefox"
    }

    {
      "metric": {
        "durations": [
          746.559,
          1002.809
        ],
        "fast": 746.559,
        "geometric_mean": 865.249,
        "measurments": 2,
        "metrics": [
          {
            "date": "2015-02-17T03:02:27.682Z",
            "duration": 746.559,
            "emberVersion": "1.8.1",
            "id": "d828e5b6-c5c2-4fee-8bf3-2d08d97ed36d",
            "pathname": "/metrics"
          },
          {
            "date": "2015-02-17T03:02:11.844Z",
            "duration": 1002.809,
            "emberVersion": "1.8.1",
            "id": "e65effb9-4756-4642-8397-1757c4f3be15",
            "pathname": "/metrics"
          }
        ],
        "name": "metrics_table",
        "slow": 1002.809,
        "userAgents": [
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:33.0) Gecko/20100101 Firefox/33.0",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0"
        ],
        "emberVersion": "1.8",
        "platform": "Macintosh",
        "browser": "Firefox"
      }
    }

Perhaps I'll use the queries and API endpoints for my metrics collection and reporting to see how the next version of Ember.js does, or see how a feature change impacts performance.