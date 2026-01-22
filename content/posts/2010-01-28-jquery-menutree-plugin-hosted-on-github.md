---
title: jQuery MenuTree Plugin Hosted on github.com
slug: jquery-menutree-plugin-hosted-on-github
published_at: '2010-01-28'
author: pixelhandler
tags: []
meta_description: |-
  This is my first post of social code using the github repository at :

  [http://github.com/pixelhandler/jQuery-MenuTree-
  Plugin/](http://github.com/pixelhandl...
---

<h2>A JavaScript plugin based on jQuery library that builds an expandable/collapsable menu tree from a list element</h2>

<ul>
<li><p>Requires JavaScript library: <a href="http://jquery.com/">jQuery</a></p></li>
<li><p>Developed using jQuery version 1.4 ... <a href="http://plugins.jquery.com/project/menuTree">Plugin page</a></p></li>
<li><p>Demo of the plugin behavior showing both lists and definition list... <a href="http://www.pixelhandler.com/menutree/jQuery-MenuTree-Plugin/example/">Demo</a></p></li>
<li><p>Status : New plugin, give it a try!</p></li>
<li><p>Tracer plugin added and featured with demo.</p></li>
<li><p>Blog post for MenuTree plugin on my blog... <a href="http://www.pixelhandler.com/blog/2010/01/28/jquery-menutree-plugin-hosted-at-github-com/">Blog</a></p></li>
</ul>


<h2>How to build a menu tree that is expandable with jQuery</h2>

<p>Your html will need to link to the jQuery plugin in the head element</p>

<p><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js" type="text/javascript" charset="utf-8"></script></p>

<p>Your html markup needs to use a list, see github link for reference.</p>


<p>menuTree plugin plugin uses a few CSS classes for visual design...</p>
<pre name="code" class="css">

#myTree .menuTree:before {
	content: "[+] ";
}

#myTree .expanded:before {
	content: "[-] ";
}

#myTree .collapsed {
	display: none;
}

</pre>
<p>At the end of your html markup, before the closing body element use a script to setup the function...</p>
<pre name="code" class="js">

$(document).ready(function() {

	$('#myTree').menuTree({
    	animation: true,
		handler: 'slideToggle',
		anchor: 'a[href="#"]',
		trace: true
	});

});

</pre>
<p>This plugin has default options which you may override. The animation option may use jQuery <strong>toggle or slideToggle</strong> methods, or just use the default <strong>css</strong> option to show/hide the child list(s).</p>

<p>When called with the animation: true option the plugin uses the handler option to select <em>slideToggle</em> or <em>toggle</em> method to add effects to the display of child menu(s). You may set the speed as you please, e.g. speed: 'slow'. Also, you may indicate what the child menu(s) are marked up with, e.g. listElement: <em>'ol'</em> instead of the default listElement: <em>'ul'</em></p>

<p>The default options:</p>
<pre name="code" class="js">

$.fn.menuTree.defaults = {

	// setup animation
	animation: false, 
	handler: 'css',
	speed: 'fast',
	// setup hooks in markup
	listElement: 'ul',
	anchor: 'a[href="#"]',
	// uses 'tracer' plugin
	trace: false
};

</pre>
<p>If you have any questions, please feel free to ask them on the jQuery
meetup site, found here:<br />
<a href="http://meetups.jquery.com/group/jquerylosangeles">http://meetups.jquery.com/group/jquerylosangeles</a></p>
