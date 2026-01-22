---
title: jQuery Plugin to 'matchHeight' of Multiple Columns With Floating Elements
slug: jquery-plugin-to-matchheight-of-multiple-columns-with-floating-elements
published_at: '2010-08-26'
author: pixelhandler
tags: []
meta_description: |-
  jQuery plugin to line up columns in a CSS layout with floating divs. This code
  has an option to use a fixed height instead of the greatest height among the
  c...
---


    
    (function($) {
    /**
     *  .matchHeight()
     *    - match heights of multiple columns that use css layout with floating elements
     */
    $.fn.matchHeight = function(options) {
        // set the containing element and set elements used as columns
        var defaults = {
            container : '.main',
            columns   : 'div',
            excluded  : '.dontChangeThis, .dontChangeThat',
            fixed     : 200
        };
        var opts = $.extend(defaults, options);
        return this.each(function() {
            var _ = { self : $(this) };
            _.px = {};
            _.cols = $(opts.container+' > '+opts.columns);
            _.cols.each(function(index) {
                _.px.index = $(this).height();
                if ($(opts.excluded).length>0) {
                    _.colheight = opts.fixed;
                    return;
                } else {
                    if (index < 1) {
                        _.colheight = _.px.index;
                    } else {
                        if (_.px.index > _.colheight) {
                            _.colheight = _.px.index;
                        }
                    }
                }
            }).each(function(index) {
                $(this).css({ height : _.colheight });
            });
        });
    };
    })(jQuery);
    
    //
    // Call the plugin on a containing layout element with multiple columns
    //
    
    /**
     * Stuff to do as soon as the DOM is ready
     *  - enable plugin behavior(s)
     */
    $(function() {
        $('.main-container')matchHeight({
                    container : '.main',
                    columns   : 'div.cols',
                    excluded  : 'body.page2, div.noColumns',
                    fixed  : 200
         });
        // or us the defaults
        // $('.container').matchHeight();
    });
