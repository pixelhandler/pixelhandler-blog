---
title: Command Line Tip to Find Running Apps and Kill 'Em
slug: command-line-tip-to-find-running-apps-and-kill-em
published_at: '2010-08-10'
author: pixelhandler
tags: []
meta_description: Find running apps, find running app on port number, kill process,
  first number listed follow above result
---

## find running apps :

    
    ps aux | grep ruby
    ps -awwx | grep mysql
    

## find running app on port number

    
    ps aux | grep 12005
    

## kill process, first number listed follow above result

    
    kill XXXXX
    
