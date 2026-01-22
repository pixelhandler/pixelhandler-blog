---
title: Apache Directive to Combine .js and .css Files
slug: apache-directive-to-combine-js-and-css-files
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  I like to keep CSS files named separately like ; reset.css, elements.css,
  classes.css, layout.css and so on. Also, I like to keep jQuery plugins in
  individua...
---

    # Allows concatenation from files ending with .js and .css  
    # In styles.combined.css use...
    #   <!--#include file="reset.css" -->
    #   <!--#include file="layout.css" -->
    # these will included into this single file
    
    <FilesMatch ".combined.js">
            Options +Includes
            SetOutputFilter INCLUDES
    </FilesMatch>
    <FilesMatch ".combined.css">
            Options +Includes
            SetOutputFilter INCLUDES
    </FilesMatch>