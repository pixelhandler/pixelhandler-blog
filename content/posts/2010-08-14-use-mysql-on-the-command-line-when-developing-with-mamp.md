---
title: Use Mysql on the Command Line When Developing With MAMP
slug: use-mysql-on-the-command-line-when-developing-with-mamp
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  Developing with MAMP, if so then use mysql on the command line (terminal app).
  Update your ~/.profile file to use the MAMP mysql PATH. If you use textmate…
---


    
    mate ~/.profile
    

Edit your path in .profile adding /Applications/MAMP/Library/bin:$PATH

    
    export PATH="/usr/local/bin:/usr/local/mysql/bin:/Applications/MAMP/Library/bin:$PATH"
    

Also after you start MAMP to use mysql on command line :

    
    sudo ln -s /Applications/MAMP/tmp/mysql/mysql.sock /tmp/mysql.sock
    
