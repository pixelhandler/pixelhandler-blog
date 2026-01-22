---
title: searchText() jQuery Plugin to Add Helper Text in Search Input
slug: searchtext-jquery-plugin-to-add-helper-text-in-search-input
published_at: '2010-09-02'
author: pixelhandler
tags: []
meta_description: |-
  This jQuery plugin script added text to an input field in a search form. The
  defaults are set to the IDs used in a WordPress search form. The behavior can
  be...
---


    
    (function($) {
    /**  
     *  .searchText()
     *		add some helper text to search input field
     */
    $.fn.searchText = function(options) {
    	var defaults = {
    		helperText : 'Search',
    		inputId    : '#s',
    		forceReset : false
    	};
    	var opts = $.extend({},defaults, options);
    	return this.each(function() {
    		// write helper text inside input field
    		$(opts.inputId).bind('blur', {msg: opts.helperText}, function(event){
    			// $.log(event.type + " : " + event.target.id + " : " + event.data.msg);
    			var _self = $(this);
    			if (_self.val() === '') {
    				_self.val(event.data.msg);
    			}
    			return false;
    		}).bind('focus', {msg: opts.helperText}, function(event){
    			var _self = $(this);
    			if (opts.forceReset || _self.val() === event.data.msg) {
    				// clear search input form
    				_self.val('');
    			}
    			return false;
    		}).trigger('blur');
    	});
    };
    })(jQuery);
    
    // Use the plugin in your document ready block
    // Use plugin when WordPress search form id is present
    //   - $('#searchform').searchText();
    // Call plugin with option to force reseting the text on focus
    $('#searchform').searchText({
    	helperText : 'Search',
    	inputId    : '#s',
    	forceReset : true
    });

**Use the plugin in your document ready :**
    
    
    // use plugin when WordPress search form id is present
    $('#searchform').searchText();
    

**Or,**
    
    
    // call plugin with option to force reseting the text on focus
    $('#searchform').searchText({
    	helperText : 'Search',
    	inputId    : '#s',
    	forceReset : true
    });
    
    
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <title>HTML for .searchText() jQuery Plugin, custom helper text input value</title>
      <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    </head>
    <body>
      <h1>.searchText() jQuery Plugin, adding search helper text / behavior</h1>
      <ol>
        <li>
          <p><strong>Default options</strong>, &quot;Search&quot; text added to input&hellip;</p>
          <form action="#" method="get" accept-charset="utf-8" id="defaultform">
            <input type="text" name="s" value="" id="d" />
            <input type="submit" val="submit" name="submit" />
          </form>
        </li>
      
        <li>
          <p>Extend default options, forcing text to <strong>reset upon re-entry</strong>&hellip;</strong></p>
          <form action="#" method="get" accept-charset="utf-8" id="searchform">
            <input type="text" name="s" value="" id="s" />
            <input type="submit" val="submit" name="submit" />
          </form>
        </li>
      
        <li>
          <p>Extend default options, with <strong>custom helper</strong> text&hellip;</p>
          <form action="#" method="get" accept-charset="utf-8" id="findform">
            <input type="text" name="s" value="" id="f" />
            <input type="submit" val="submit" name="submit" />
          </form>
        </li>
      
        <li>
          <p>Extend default options, with <strong>helperText</strong> and <strong>forceReset</strong> options&hellip;</p>
          <form action="#" method="get" accept-charset="utf-8" id="whereform">
            <input type="text" name="s" value="" id="w" />
            <input type="submit" val="submit" name="submit" />
          </form>
        </li>
      </ol>
      <h2>Unit Tests</h2>
      <p><a href="unitTests.html">Click to run tests with QUnit!</a></p>
      <script src="jquery.htmlsrc.searchText.js"></script>
      <script type="text/javascript" charset="utf-8">
      (function($){
        // 1. Extend default options
        $('#defaultform').searchText({
        	inputId    : '#d'
        });
    
        // 2. Extend default options, forcing field to reset upon re-entry
        // was already in the jquery.htmlsrc.searchText.js file
    
        // 3. Extend default options, with custom helper text
        $('#findform').searchText({
        	helperText : 'Find something...',
        	inputId    : '#f'
        });
    
        // 4. 
        $('#whereform').searchText({
        	helperText : 'where is...',
        	inputId    : '#w',
        	forceReset : true
        });
    
      })(this.jQuery);
      </script>
    </body>
    </html>

**Clone the code snippet with git…**
    
    
    git clone git://gist.github.com/665652.git
    
    
    // documentation on writing tests here: http://docs.jquery.com/QUnit
    // source : https://github.com/jquery/qunit
    
    // global var htmlsrc for namespace
    if (!window.htmlsrc) {var htmlsrc = {};}
    /*
     * .searchText() testing user interaction with form input behaviors
     */
    
    /* namespace */
    module('namespace check');
    test('is htmlsrc a global variable',function(){
    	expect(1);
    	ok( window.htmlsrc, 'htmlsrc namespace is present');
    });
    
    /* fixture */
    htmlsrc.testMarkup = '#qunit-fixture';
    
    module(".searchText() jQuery Plugin", {
      setup: function() {
        htmlsrc.testForm = '<form action="submit" method="get" accept-charset="utf-8" id="searchform"><input type="text" name="s" value="" id="s" /><input type="submit" val="&rarr;" name="submit" /></form>';
      },
      teardown: function() {
        $(htmlsrc.testMarkup).empty();
      }
    });
    
    test("Search form value empty prior to using searchText plugin", function() {
    
      // Arrange
      var _Form, _Selector, _Value;  
      _Form = $(htmlsrc.testForm).appendTo(htmlsrc.testMarkup);
    
      // Act
      _Selector = 'input[type="text"]';
      _Value = $(_Selector,_Form).val();
    
      // Assert
      expect(1);
      same(_Value,"", "text input field should have be empty, value is empty string");
    });
    
    test("searchText jQuery Plugin With No Parameters", function() {
    
      // Arrange
      var _Form, _Selector, _Value = {};  
      _Form = $(htmlsrc.testForm).appendTo(htmlsrc.testMarkup);
    
      // Act
      _Form.searchText();
      _Selector = 'input[type="text"]';
      _Value.a = $(_Selector, _Form).val();
      _Value.b = $(_Selector, _Form).focus().val();
      _Value.c = $(_Selector, _Form).focus().blur().val();
      $(_Selector, _Form).blur();
      _Value.c = $(_Selector, _Form).val();
    
      // Assert
      expect(3);
      same(_Value.a, "Search", "text input field should have the text 'Search'");
      same(_Value.b, "", "text input field should not have any text on focus event");
      same(_Value.c, "Search", "text 'Search' is devault after blur event");
    });
    
    test("searchText jQuery Plugin With helperText Parameter", function() {
    
      // Arrange
      var _Form, _Selector, _Value = {};
      _Form = $(htmlsrc.testForm).appendTo(htmlsrc.testMarkup);
      _Selector = 'input[type="text"]';
    
      // Act
      _Form.searchText({ 
        helperText	: "Search our site..."
      });
      // get values at different stages of user interaction with text input field
      _Value.a = $(_Selector, _Form).val();
      // simulate user entering text within input field
      $(_Selector, _Form).focus();
      _Value.b = $(_Selector, _Form).val();
      $(_Selector, _Form).val("find it please");
      // simulate user leaving input field
      $(_Selector, _Form).blur();
      _Value.c = $(_Selector, _Form).val();
      // simulate user re-entering input
      $(_Selector, _Form).focus();
      _Value.d = $(_Selector, _Form).val();
    
      // Assert
      expect(4);
      same(_Value.a, "Search our site...", "text input field should have the custom text 'Search our site...'");
      same(_Value.b, "", "text input field should not have any text on focus event");
      same(_Value.c, "find it please", "new text value is kept after blur event");
      same(_Value.d, "find it please", "new text value is not reset after re-entering input field");
    });
    
    test("searchText jQuery Plugin With forceReset Parameter", function() {
    
      // Arrange
      var _Form, _Selector, _Value = {};
      _Form = $(htmlsrc.testForm).appendTo(htmlsrc.testMarkup);
      _Selector = 'input[type="text"]';
    
      // Act
      _Form.searchText({ 
        forceReset : true
      });
      // get values at different stages of user interaction with text input field
      _Value.a = $(_Selector, _Form).val();
      // simulate user entering text within input field
      $(_Selector, _Form).focus();
      _Value.b = $(_Selector, _Form).val();
      $(_Selector, _Form).val("I am looking for cheese");
      // simulate user leaving input field
      $(_Selector, _Form).blur();
      _Value.c = $(_Selector, _Form).val();
      // simulate user re-entering input
      $(_Selector, _Form).focus();
      _Value.d = $(_Selector, _Form).val();
    
      // Assert
      expect(4);
      same(_Value.a, "Search", "text input field should have the default text 'Search'");
      same(_Value.b, "", "text input field should not have any text on focus event");
      same(_Value.c, "I am looking for cheese", "new text value is kept after blur event");
      same(_Value.d, "", "new text value is forced to reset after re-entering (focus) input");
    });
