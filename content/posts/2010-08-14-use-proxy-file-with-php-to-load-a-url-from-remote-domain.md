---
title: Use Proxy File With PHP to Load a URL From Remote Domain
slug: use-proxy-file-with-php-to-load-a-url-from-remote-domain
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  To get around cross domain issues use a local proxy.php file to load the
  remote url that you would like to use on your domain and interact with AJAX.
---

## Create your proxy.php file

    
    
    <?php
    // Set your return content type
    header('Content-type: text/html');
    
    // Website url to open
    $daurl = 'htts://domain.com';
    
    // Get that website's content
    $handle = fopen($daurl, "r");
    
    // If there is something, read and return
    if ($handle) {
        while (!feof($handle)) {
            $buffer = fgets($handle, 4096);
            echo $buffer;
        }
        fclose($handle);
    }
    ?>
    

### Call your proxy file with AJAX using jQuery

    
    
    // requires jQuery $
    $(function(){ 
    	// you will need a proxy script to load remote content
    	var proxy = 'proxy.php'; 
    	$('div.container').hide();
    	$('div.container').load( proxy + ' div#id', function() {
    		$('div.container').show()
    	});
    });
    
