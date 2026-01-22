---
title: Use Newer jQuery Features When Your App Is Stuck on Older Version
slug: use-newer-jquery-features-when-your-app-is-stuck-on-older-version
published_at: '2011-10-08'
author: pixelhandler
tags: []
meta_description: |-
  ## So, your app only uses a certain version of jQuery from last year sometime, e.g. v 1.4.2

  Not a problem, you can add in the newer features you need by cop...
---

### Links on the topic of Deferreds / Promises

* <http://api.jquery.com/jQuery.ajax/>
* <http://msdn.microsoft.com/en-us/scriptjunkie/gg723713>
* <http://quickleft.com/blog/jquery-15-hotness-part-2> | <https://gist.github.com/862567>
* <http://joseoncode.com/2011/09/26/a-walkthrough-jquery-deferred-and-promise/>

## Short explanation

* You really want to use jQuery methods : $.Deferred() .promise() .done() .fail() .isResolved() .isRejected() .then() .always() .pipe() .when()
* You may be using a service to get some data e.g. via .ajax()
* You need both ajax actions to complete (with success) then your code responds after both actions are done.
* See Gists below ... <https://gist.github.com/1273143> | <https://gist.github.com/1273133>

**See working example at** : <http://pixelhandler.com/downloads/code/deferred-promise/>

## Code …

    
    <!docType html>
    <html>
    <head>
      <title>Deferred / Promise</title>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
      <script type="text/javascript" src="jquery-1.6.4-promises.js">// get script at https://gist.github.com/1273133</script>
    </head>
    <body>
    <h1>Deferred / Promise Example using jQuery 1.4.2 by adding implementation in newer version</h1>
    <script type="text/javascript" charset="utf-8">
    
    (function($){ // IIFE ...
      
    $(function(){ // doc ready ...
      
      var container, things, promises;
          
      // Code below borrowed from ...
      //    Deferreds post : http://quickleft.com/blog/jquery-15-hotness-part-2
      //    Code : https://gist.github.com/862567
    
      container = $( "<div/>" ).appendTo( document.body );
      $('div').html("<p>jQuery version:" + jQuery.fn.jquery + ". Hang on this should take about 5 seconds to complete.</p>");
    
      // List of resources we want to load files on http://pixelhandler.com/ domain
      things = [
        {
          url: "/downloads/code/deferred-promise/services/?type=XML",
          data_type: "xml",
          name: "Products XML"
        },
        {
          url: "/downloads/code/deferred-promise/services/?type=JSON",
          data_type: "json",
          name: "Products JSON"
        }
      ];
    
      // Container to hold our promises
      promises = [];
    
      function getSomething(thing){
    
        // Create our deferred
        var dfd = $.Deferred();
    
        // - Make a request and resolve our deferred onSuccess
        // - You can get super fancy here with $.ajax and explicitly
        //   set fail or rejected states
        $.get(
          thing.url,
          function() { dfd.resolve(); },
          thing.data_type
        );
    
        // We return a promise so we can watch it for a resolution
        return dfd.promise();
    
      }
    
      // Iterate through our requests
      $.each( things, function(_, thing){
        // - Each getSomething() call will return a promise, so let's
        //   push them into our promises array
        promises.push( getSomething(thing).done(function(){
          // - This is an inline done() handler which will fire when
          //   the individual promise is resolved
          container.append( '<p>Loaded ' + thing.name  + '. - Promise done.</p>' );
          // - You could string other handlers like fail() after this
          //   if you want to try a broken link or other situation
        }) );
      });
    
      setTimeout(function(){
    
        // Apply entire array of promises to a $.when listener
        $.when.apply( null,  promises ).then(function(){
          // All promises have been resolved :)
          container.append( '<p class="green">Finished loading All Files - All promises have been resolved. (We can even wait a bit before we handle our promises. If they have already been resolved, jQuery will remember!)</p>' );
        });
    
      }, 5000);
    
    }); // end ready
    
    }(jQuery)); // end IIFE
    
    </script>
    </body>
    </html>

**Uses code from:**
    
    (function($){
    
        var // Promise methods
            promiseMethods = "done fail isResolved isRejected promise then always pipe".split( " " ),
            // Static reference to slice
            sliceDeferred = [].slice;
    
        if (typeof $ !== 'function') {
            return false;
        } else {
            jQuery.each(promiseMethods, function(){
                if (typeof jQuery[this] !== 'undefined') {
                    return false;
                }
            });
        }
    
        // dependencies
        if (typeof jQuery.type === 'undefined') {
            var class2type = {};
            // Populate the class2type map
            jQuery.each("Boolean Number String Function Array Date RegExp Object".split(" "), function(i, name) {
                class2type[ "[object " + name + "]" ] = name.toLowerCase();
            });
            jQuery.extend({
                type: function( obj ) {
                    return obj == null ?
                        String( obj ) :
                        class2type[ toString.call(obj) ] || "object";
                }
                // redefine isFunction using type method
                //isFunction: function( obj ) {
                //  return jQuery.type(obj) === "function";
                //}
            });
    
        }
    
        jQuery.extend({
            // Create a simple deferred (one callbacks list)
            _Deferred: function() {
                var // callbacks list
                    callbacks = [],
                    // stored [ context , args ]
                    fired,
                    // to avoid firing when already doing so
                    firing,
                    // flag to know if the deferred has been cancelled
                    cancelled,
                    // the deferred itself
                    deferred  = {
    
                        // done( f1, f2, ...)
                        done: function() {
                            if ( !cancelled ) {
                                var args = arguments,
                                    i,
                                    length,
                                    elem,
                                    type,
                                    _fired;
                                if ( fired ) {
                                    _fired = fired;
                                    fired = 0;
                                }
                                for ( i = 0, length = args.length; i < length; i++ ) {
                                    elem = args[ i ];
                                    type = jQuery.type( elem );
                                    if ( type === "array" ) {
                                        deferred.done.apply( deferred, elem );
                                    } else if ( type === "function" ) {
                                        callbacks.push( elem );
                                    }
                                }
                                if ( _fired ) {
                                    deferred.resolveWith( _fired[ 0 ], _fired[ 1 ] );
                                }
                            }
                            return this;
                        },
    
                        // resolve with given context and args
                        resolveWith: function( context, args ) {
                            if ( !cancelled && !fired && !firing ) {
                                // make sure args are available (#8421)
                                args = args || [];
                                firing = 1;
                                try {
                                    while( callbacks[ 0 ] ) {
                                        callbacks.shift().apply( context, args );
                                    }
                                }
                                finally {
                                    fired = [ context, args ];
                                    firing = 0;
                                }
                            }
                            return this;
                        },
    
                        // resolve with this as context and given arguments
                        resolve: function() {
                            deferred.resolveWith( this, arguments );
                            return this;
                        },
    
                        // Has this deferred been resolved?
                        isResolved: function() {
                            return !!( firing || fired );
                        },
    
                        // Cancel
                        cancel: function() {
                            cancelled = 1;
                            callbacks = [];
                            return this;
                        }
                    };
    
                return deferred;
            },
    
            // Full fledged deferred (two callbacks list)
            Deferred: function( func ) {
                var deferred = jQuery._Deferred(),
                    failDeferred = jQuery._Deferred(),
                    promise;
                // Add errorDeferred methods, then and promise
                jQuery.extend( deferred, {
                    then: function( doneCallbacks, failCallbacks ) {
                        deferred.done( doneCallbacks ).fail( failCallbacks );
                        return this;
                    },
                    always: function() {
                        return deferred.done.apply( deferred, arguments ).fail.apply( this, arguments );
                    },
                    fail: failDeferred.done,
                    rejectWith: failDeferred.resolveWith,
                    reject: failDeferred.resolve,
                    isRejected: failDeferred.isResolved,
                    pipe: function( fnDone, fnFail ) {
                        return jQuery.Deferred(function( newDefer ) {
                            jQuery.each( {
                                done: [ fnDone, "resolve" ],
                                fail: [ fnFail, "reject" ]
                            }, function( handler, data ) {
                                var fn = data[ 0 ],
                                    action = data[ 1 ],
                                    returned;
                                if ( jQuery.isFunction( fn ) ) {
                                    deferred[ handler ](function() {
                                        returned = fn.apply( this, arguments );
                                        if ( returned && jQuery.isFunction( returned.promise ) ) {
                                            returned.promise().then( newDefer.resolve, newDefer.reject );
                                        } else {
                                            newDefer[ action + "With" ]( this === deferred ? newDefer : this, [ returned ] );
                                        }
                                    });
                                } else {
                                    deferred[ handler ]( newDefer[ action ] );
                                }
                            });
                        }).promise();
                    },
                    // Get a promise for this deferred
                    // If obj is provided, the promise aspect is added to the object
                    promise: function( obj ) {
                        if ( obj == null ) {
                            if ( promise ) {
                                return promise;
                            }
                            promise = obj = {};
                        }
                        var i = promiseMethods.length;
                        while( i-- ) {
                            obj[ promiseMethods[i] ] = deferred[ promiseMethods[i] ];
                        }
                        return obj;
                    }
                });
                // Make sure only one callback list will be used
                deferred.done( failDeferred.cancel ).fail( deferred.cancel );
                // Unexpose cancel
                delete deferred.cancel;
                // Call given func if any
                if ( func ) {
                    func.call( deferred, deferred );
                }
                return deferred;
            },
    
            // Deferred helper
            when: function( firstParam ) {
                var args = arguments,
                    i = 0,
                    length = args.length,
                    count = length,
                    deferred = length <= 1 && firstParam && jQuery.isFunction( firstParam.promise ) ?
                        firstParam :
                        jQuery.Deferred();
                function resolveFunc( i ) {
                    return function( value ) {
                        args[ i ] = arguments.length > 1 ? sliceDeferred.call( arguments, 0 ) : value;
                        if ( !( --count ) ) {
                            // Strange bug in FF4:
                            // Values changed onto the arguments object sometimes end up as undefined values
                            // outside the $.when method. Cloning the object into a fresh array solves the issue
                            deferred.resolveWith( deferred, sliceDeferred.call( args, 0 ) );
                        }
                    };
                }
                if ( length > 1 ) {
                    for( ; i < length; i++ ) {
                        if ( args[ i ] && jQuery.isFunction( args[ i ].promise ) ) {
                            args[ i ].promise().then( resolveFunc(i), deferred.reject );
                        } else {
                            --count;
                        }
                    }
                    if ( !count ) {
                        deferred.resolveWith( deferred, args );
                    }
                } else if ( deferred !== firstParam ) {
                    deferred.resolveWith( deferred, length ? [ firstParam ] : [] );
                }
                return deferred.promise();
            }
        });
    
    
    }(jQuery));

