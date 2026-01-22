---
title: Boilerplate Code for jQuery Plugin With Debug and Logging Methods
slug: boilerplate-code-for-jquery-plugin-with-debug-and-logging-methods
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  jQuery provides a quick and easy way to extend behavior. I use this code below
  to begin when writing a new jQuery plugin.
---


    
    //jQuery.noConflict();
    (function($) { // $ is jQuery
        // plugin for yada yada
        $.fn.yadayada = function(options) {
            var defaults = {
                foo : 'bar'
            };
            // Extend our default options with those provided.
            var opts = $.extend({}, defaults, options);
            // Do something to each item
            return this.each(function() {
                var _ = { obj : $(this) };
                // get settings from options
                _.foo = _.obj.find(opts.foo);
                /*
                    ... code to return, chained
                */
            });
        };
        // debugging methods
        $.fn.debug = function() {
            return this.each(function(){
                alert(this);
            });
        };
        $.log = function(message) {
            if(window.console) {
                 console.debug(message);
            } else {
                 alert(message);
            }
        };
        // end plugin
        // Stuff to do as soon as the DOM is ready;
        $(function() {
            var something = $('div.something');
            try {
                if (something.length>0) {
                    something.yadayada({ foo: 'no bars' });
                }
            } catch(oops) { $.log(oops); }
        });
    })(jQuery);