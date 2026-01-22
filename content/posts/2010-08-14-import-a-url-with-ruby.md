---
title: Import a URL With Ruby
slug: import-a-url-with-ruby
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  Simple blocks to use as a method to import a url in a rails app, like using
  content from another api import HTML with Ruby (importHTML.rb)
---


    
    def importHTML
      require 'open-uri'
      @source = open(&quot;http://domain.com/some.html&quot;).read
    end
    
    # uses a reference parameter when getting remote XML
    def importXML
      require 'open-uri'
      @aclass = AClass.find(params[:id]) # expecting a param named ref
      @content = open(&quot;http://domain.com&quot; + @aclass.ref + &quot;&amp;type=xml&quot;).read
      respond_to do |format|
        format.xml  { render :xml =&gt; @content }
      end
    end
    
