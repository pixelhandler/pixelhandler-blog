---
title: Images Loaded or Not? Check With JavaScript
slug: images-loaded-or-not-check-with-javascript
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  For sites with a CMS or some easy tool to upload and break images it can be
  helpful to test if the images are loaded, especially if you have additional
  behav...
---

## Javascript function to test if image is loaded already :

    
    // Check if images load properly
    // returns false if image not loaded
    function imgOK(img) {
        if (!img.complete) {
            return false;
        }
        if (typeof img.naturalWidth != "undefined" && img.naturalWidth == 0) {
            return false;
        }
        return true;
    }
     
    // Note: using prototype js library for $, $$
    // Test if images load ok
    var tnLink = $$('.more-views a');
    // Hide links to more views when images do no load properly.
    if (tnLink.length>0) {
        document.observe("dom:loaded", function() {
            tnLink.each(function(s, index) {
                var tnImg = tnLink[index].firstDescendant();
                var obj = $(s).firstDescendant();
                console.log(tnImg.src + " > is ok : " + imgOK(obj));
                if ( imgOK(obj) == false) {
                    console.log('bad image!');
                    $(s).addClassName('no-display');
                }
            });
        });
    }
 

### Define a CSS class to hide the link with a bad image :

CSS - no-display.css

    .no-display {
    	display: none;
    }


_There, no unexpected broken images in view._