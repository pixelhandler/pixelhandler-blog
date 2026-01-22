---
title: Clean Up Directories Prior to Initializing Repository
slug: clean-up-directories-prior-to-initializing-repository
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: Use command line to clean up directories prior to initializing repository.
---


  * remove junk like .DS_Store or clean out repositories like folders named CVS .svn .git 
  * -type d for directories f for files
    
    
    find . -name '.svn' -type d | xargs echo
    
    find . -name '.svn' -type d | xargs rm -rf
    
    find . -name '.git' -exec rm -rf {} ;
    
    find . -name '.DS_Store' -type f | xargs rm -rf
    
