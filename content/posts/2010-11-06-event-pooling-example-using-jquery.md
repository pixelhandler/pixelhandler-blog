---
title: Event Pooling Example Using jQuery
slug: event-pooling-example-using-jquery
published_at: '2010-11-06'
author: pixelhandler
tags: []
meta_description: |-
  Example of using custom events in jQuery for event pooling. Elements broadcast
  (trigger) events and the document listens (binds) responding with calls to
  han...
---

<!-- Working example at : [code.html-src.com/621429](http://code.html-
src.com/621429/) be sure to view your browser console. -->
 
    
    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="utf-8"/>
        <title>Event Pooling, or perhaps Pub/Sub</title>
        <script type="text/javascript" charset="utf-8" src="http://ajax.microsoft.com/ajax/jQuery/jquery-1.4.2.min.js"></script>
    </head>
    <body>
    <strong>Who is this?</strong>
    <form action="#" method="get" accept-charset="utf-8" id="whoisit">
        <p><label for="name">name</label> <input type="text" name="name" value="" id="name">
        </p>
        <p><label for="email">email</label> <input type="email" name="email" value="" id="email">
        </p>
        <p><input type="submit" value="Continue &rarr;" id="submit"></p>
    </form>
    </body>
    <script type="text/javascript" charset="utf-8" src="script.js"></script>
    </html>
    
    // Event pooling script
    (function($) { // $ is jQuery 
    
        var eventpooling = function() {
            // broadcast events on elements
            $('#name').bind('blur', function(event) {
                $(document).trigger('NAME_CHANGED',event.target);
            });
            $('#email').bind('blur', function(event) {
                $(document).trigger('EMAIL_CHANGED',event.target);
            });
            $('#submit').bind('click', function(event) {
                $(document).trigger('SUBMIT_CLICKED',event);
            });
    
            // Pool events on document
            $(document).bind('NAME_CHANGED EMAIL_CHANGED SUBMIT_CLICKED', function(event) {
                //Handler(s)
                $.log(event.type);
            })
            .bind('NAME_CHANGED', function(event, obj) {
                //Handler(s)
                nameChangedHandler(event, obj);
            })
            .bind('EMAIL_CHANGED', function(event, obj) {
                //Handler(s)
                emailChangedHandler(event, obj);
            })
            .bind('SUBMIT_CLICKED', function(event) {
                //Handler(s)
                alert("form valid? "+submitClickHandler(event));
            });
    
            // properties
            var IS_NAME_VALID, IS_EMAIL_VALID;
    
            // Common methods
            function responder(str) {
                var response = "Are you really named: ";
                return response + str;
            }
            function readyToSubmit() {
                var ready = (IS_NAME_VALID === true && IS_EMAIL_VALID === true) || false;
                if (ready === true) {
                    $('#submit').removeAttr('disabled');
                }
                return ready;
            }
    
            // validation methods
            function validater(event,obj) {
                $.log('validating: '+ event.type);
                var valid = false;
                var $obj = $(obj);
                $obj.str = $obj.val();
                $.log('value: '+ $obj.str);
                if (event.type == 'NAME_CHANGED') {
                    valid = notEmpty($obj.str);
                    IS_NAME_VALID = valid;
                }
                if (event.type == 'EMAIL_CHANGED') {
                    if (notEmpty($obj.str) && validEmail($obj.str)) {
                        valid = true;
                        IS_EMAIL_VALID = valid;
                    } 
                }
                $.log('valid field: '+ valid);
                return readyToSubmit();
            }
            function notEmpty(str) {
                if (str!=='') {
                    return true;
                } else {
                    return false;
                }
            }
            function validEmail(elmValue){
               var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
               return emailPattern.test(elmValue);
            }
    
            // Event handlers
            function submitClickHandler(event) {
                validater(event);
                return readyToSubmit();
            }
            function nameChangedHandler(event, obj) {
                var name = $(obj).val();
                $.log(responder(name));
                validater(event,obj);
            }
            function emailChangedHandler(event, obj) {
                var email = $(obj).val();
                alert('please confirm your email: '+ email);
                validater(event,obj);
            }
            // initialize behavior
            var init = (function(){
                $('#submit').attr('disabled', 'disabled');
            })();
            return init;
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
        
        // doc ready
        $(function() {
            try {
                eventpooling();
            } catch(oops) {
                $.log(oops);
            }
        });
        
    })(jQuery);
