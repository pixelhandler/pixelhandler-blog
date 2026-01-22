---
title: Hijack Form's Submit Onclick, Validate, and Use Enter Key to Post Form
slug: hijack-form-submit-onclick-validate-and-use-enter-key-to-post-form
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  Depending on the platform you develop on sometimes you may need to hijack an
  onclick attribute to first do some form validation on the client side. It
  would ...
---


    
    // using jQuery library and validation plugin in this code
    // for checking keycodes
    function getKeyCode(event) {
        var keycode = (event.keyCode ? event.keyCode : (event.which ? event.which : event.charCode));
        return keycode;
    }
     
    // is there an anchor as Submit button?
    var $submit = $('a[id$="_submit"]');
    // is there any behavior already on submit, like -> onclick="__doPostBack(...)"
    $submit.action = $submit.attr('onclick'); 
     
    $submit.click(function(e){
        // using jQuery validation plugin to validate
        $submit.valid = $('.myform').valid();
        if (!$submit.valid) {
            e.preventDefault();
        } else {
            // process original onclick stuff
            $($submit.action).trigger('click');
        }
    });
     
    // submit with enter key
    $(".myform input").bind("keydown", function(event) {
        // track enter key
        var keycode = getKeyCode(event);
        // keycode for enter key
        if (keycode == 13) {
             // force the 'Enter Key' to implicitly click the Sumbit button
             $submit.click();
             return false;
        } else  {
             return true;
        }
    });
