---
title: Insert Facebook Like Button With Current Page's URL
slug: insert-facebook-like-button-with-current-page-url
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  If you are not using the full facebook .js api then here is a lightweight
  script to insert a facebook like button into a div (with id, 'social' ) [this
  examp...
---


    
    // '$' is prototype library
    (function(){
    	// use location for facebook like button
    	var $pg = {
    		url : unescape(document.location.href),
    		social : $('social') // id to place like button in
    	}
    	$pg.fb = '&lt;div id=&quot;facebook&quot;&gt;&lt;iframe';
    	$pg.fb += ' src=&quot;http://www.facebook.com/plugins/like.php?href=';
    	$pg.fb += $page.url;
    	$pg.fb += '&amp;amp;layout=button_count&amp;amp;show_faces=true&amp;amp;';
    	$pg.fb += 'width=90&amp;amp;action=like&amp;amp;colorscheme=light&amp;amp';
    	$pg.fb += 'height=30&quot; scrolling=&quot;no&quot; frameborder=&quot;0&quot; style=';
    	$pg.fb += '&quot;border:none; overflow:hidden; width:90px; ';
    	$pg.fb += 'height:30px;&quot; allowTransparency=&quot;true&quot;&gt;';
    	$pg.fb += '&lt;/iframe&gt;&lt;/div&gt;';
    	if ($pg.social) {
    		$pg.social.insert({ 'bottom' : $pg.fb });
    	};
    })($);
    
    
    
    <div id="social"></div>
    
