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

## A JavaScript plugin based on jQuery library that builds an expandable/collapsable menu tree from a list element

* Requires JavaScript library: [jQuery](http://jquery.com/)
* Developed using jQuery version 1.4 ... [Plugin page](http://plugins.jquery.com/project/menuTree)
* Demo of the plugin behavior showing both lists and definition list... [Demo](http://www.pixelhandler.com/menutree/jQuery-MenuTree-Plugin/example/)
* Status : New plugin, give it a try!
* Tracer plugin added and featured with demo.
* Blog post for MenuTree plugin on my blog... [Blog](https://pixelhandler.dev/posts/jquery-menutree-plugin-hosted-on-github)


## How to build a menu tree that is expandable with jQuery

Your html will need to link to the jQuery plugin in the head element

```html
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js"
        type="text/javascript" charset="utf-8"></script>
```

Your html markup needs to use a list, see github link for reference.

menuTree plugin uses a few CSS classes for visual design...

```css
#myTree .menuTree:before {
	content: "[+] ";
}

#myTree .expanded:before {
	content: "[-] ";
}

#myTree .collapsed {
	display: none;
}
```

At the end of your html markup, before the closing body element use a script to setup the function...

```javascript
$(document).ready(function() {

	$('#myTree').menuTree({
		animation: true,
		handler: 'slideToggle',
		anchor: 'a[href="#"]',
		trace: true
	});

});
```

This plugin has default options which you may override. The animation option may use jQuery **toggle or slideToggle** methods, or just use the default **css** option to show/hide the child list(s).

When called with the animation: true option the plugin uses the handler option to select *slideToggle* or *toggle* method to add effects to the display of child menu(s). You may set the speed as you please, e.g. speed: 'slow'. Also, you may indicate what the child menu(s) are marked up with, e.g. listElement: *'ol'* instead of the default listElement: *'ul'*

The default options:

```javascript
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
```

If you have any questions, please feel free to ask them on the jQuery
meetup site, found here:
[http://meetups.jquery.com/group/jquerylosangeles](http://meetups.jquery.com/group/jquerylosangeles)
