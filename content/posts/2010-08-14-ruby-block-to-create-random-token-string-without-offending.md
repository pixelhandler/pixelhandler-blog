---
title: Ruby Block to Create Random Token String Without Offending
slug: ruby-block-to-create-random-token-string-without-offending
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  In creating rant.cc as a short URL generator I wanted to avoid generating
  random text that would be offensive, so the block below attempts to avoid
  creating ...
---


    
    def random_token
      characters = 'BCDFGHJKLMNPQRSTVWXYZbcdfghjkmnpqrstvwxyz23456789-_'
      temp_token = ''
      srand
      TOKEN_LENGTH.times do
        pos = rand(characters.length)
        temp_token += characters[pos..pos]
      end
      temp_token
    end
    
