---
title: Fancy Up a List of Articles Into a Dynamic Rotation of Text
slug: fancy-up-a-list-of-articles-into-a-dynamic-rotation-of-text
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  This script and html are used to fancy up a list of articles then rotate the
  article teaser text…
---

## Script to change list of articles into a rotation of text

    
    
    // rotate the articles
    var $text = $('#section div.article');
    $text.remove();
    $text.teasers = [];
    $.each($text, function(){
    	$text.teasers.push(this);
    });
    $text.idx = 0;
    $text.stage = $('#section div.inset');
    $text.stage.html($text.teasers[$text.idx]);
    setInterval(function() { 
    	if ( $text.teasers.length > ($text.idx+1) ) {
    		$text.idx ++ ;
    	} else {
    		$text.idx = 0;
    	}
    	$text.stage.html($text.teasers[$text.idx]);
    }, 12000);
    

### Soure HTML that script read to rotate articles

    
    
    <div id="section"><div class="inset">
    	<div class="article">
    		<h3><a href="">link</a></h3>
    		<p>article teaser text...</p>
    	</div>
    	<div class="article">
    		<h3><a href="">link</a></h3>
    		<p>article text...</p>
    	</div>
    	<div class="article">
    		<h3><a href="">link</a></h3>
    		<p>another article text...</p>
    	</div>
    </div></div>
    
