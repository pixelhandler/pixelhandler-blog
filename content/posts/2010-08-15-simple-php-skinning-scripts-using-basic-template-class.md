---
title: Simple PHP Skinning Scripts Using Basic Template Class
slug: simple-php-skinning-scripts-using-basic-template-class
published_at: '2010-08-15'
author: pixelhandler
tags: []
meta_description: |-
  This example is based on a MAMP environment with DNS setup for a .local
  domain, using MAMP apache's httpd.conf to set up vhosts; notes on this are in
  the ind...
---

## Files used to create simple skinning scripts

* css
* style.css
* includes 

  * body_bottom.phtml
  * body_top.phtml
  * class_template.php
  * config.php
  * footer.phtml
  * head.phtml
  * topnav.phtml
  * tracking.phtml
* index.php
* js 

  * jquery.plugins.js
  * tail.js
    
    
    <?php
    /*
    See more info on this article or source for setup on .local domain with MAMP
    */
    require_once($_SERVER['DOCUMENT_ROOT'].'/includes/config.php');
    // arg "Home" appends page title, "home" is id for body, site is owner
    $template = new pageTemplate("Home","home","/",$site);
    $template->description = "yada yada";
    require_once($root.'/includes/head.phtml');
    require_once($root.'/includes/body_top.phtml');
    require_once($root.'/includes/topnav.phtml');	
    ?>
    <div id="leader" class="full-16">
    <!-- content here -->
    </div>
    <?php
    require_once($root.'/includes/footer.phtml');	
    require_once($root.'/includes/body_bottom.phtml');	
    ?>
    

### includes/config.php

    
    
    <?php
    
    # extra for testing, debugging, etc
    # die("ERROR on line:" . __line__);
    error_reporting(E_ALL);
    ini_set('display_errors','on');
    # print_r($_SERVER);
    # if (!session_id()) session_start();
    
    # Globals
    $root = $_SERVER['DOCUMENT_ROOT'];
    $site = "My Site";
    $url = $_SERVER['SERVER_NAME'];
    $prod = "domain.com";
    $local = "http://mysite.local:8888/";
    $googleAnalytics = "XX-xxxxxxx-XX";
    
    if (TRUE) { 
    	// override for local work , use FALSE for prod. use
    	$url = $local;
    } else {
    	// running in prod
    	$url = $prod;
    	if ($_SERVER['SERVER_NAME'] != $prod) {
    		header( 'Location: ' . 'http://' . $prod . '/') ;
    	}
    }
    
    # Class
    require_once($root.'/includes/class_template.php');
    ?>
    

### includes/class_template.php

    
    
    <?php 
    // template class
    
    class pageTemplate
    {
    	
    	var $title;
    	var $description;
    	var $name;
    	var $type;
    	var $dir;
    	
    	function __construct($pagetitle="",$pagetype="details",$path="",$owner="")
    	{
    		$this->title = $owner;
    		if ($this->title != "") 
    		{
    			$this->title .= " | " . $pagetitle;
    		} 
    		else 
    		{
    			$this->title = $pagetitle;
    		}
    		$this->name = $pagetitle;
    		$this->description = $pagetitle;
    		$this->type = strtolower($pagetype);
    		$this->owner = $owner;
    		$this->dir = strtolower($path);
    	}
    	
    	function style($cssfile,$stamp="")
    	{
    		echo "<link href="" . $cssfile . "?" . round(time(), -3) . "" rel="stylesheet" type="text/css" media="screen" />rn";
    	}
    	
    	function script($jsfile)
    	{
    		echo "<script src="" . $jsfile . "?" . round(time(), -3) . "" type="text/javascript" charset="utf-8"></script>rn";
    	}
    	
    	function pagetitle()
    	{
    		echo "<title>" . $this->title . "</title>rn";
    	}
    
    }
    
    ?>
    

### css/style.css

    
    
    /* =========================== 
       Setup your grid here... 
       http://html-src.com/web-dev/53/use-ruby-gem-sass-to-generate-a-css-grid-layout/
       =========================*/
    

### includes/head.phtml

    
    
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    	<?php echo $template->pagetitle(); ?>
    	<meta name="description" content="<?php echo $template->description; ?>">
    	<link rel="icon" href="favicon.ico" type="image/x-icon" />
    	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    	<?php echo $template->style("/css/style.css"); ?>
    	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    	<?php echo $template->script("/js/jquery.plugins.js"); ?>
    </head>
    

### includes/body_top.phtml

    
    
    <body id="<?php echo $template->type ?>" class="<?php echo $template->name ?>">
    <div id="wrapper">
    <div id="header" class="full-16">
    	<div class="inset">
    		<a href="#mainContent" class="accessibility">&#x2193; Skip to page content</a>
    		<a id="mainMenu" class="accessibility">Main Menu</a>
    	</div><!--/.inset-->
    	<hr class="accessibility" />
    </div>
    

### includes/topnav.phtml

    
    
    <div id="topnav">
    	<ul id="menu" class="nav">
    		<li><a href="/">Home</a><ul>
    			<li><a href="/articles/">Articles</a></li></ul>
    		</li>
    	</ul>
    </div><!--/#topnav-->
    

### index.php

    
    
    <?php
    /*
    # DNS notes, running on MAMP
    # instructions for running your site on http://mysite.local:8888/
    
    # edit your hosts file with Textmate
    mate /etc/hosts
    
    # add your site
    127.0.0.1 mysite.local
    
    # if needed flush DNS on mac 
    dscacheutil -flushcache
    
    # add vhosts include:
    mate /Applications/MAMP/conf/apache/httpd.conf 
    # the code below needs to be at the end of our httpd.conf file ...
    
    # NameVirtualHost *
    Include /Applications/MAMP/conf/apache/httpd-vhosts.conf
    
    mate /Applications/MAMP/conf/apache/httpd-vhosts.conf
    # below are the contents of the httpd-vhosts.conf file ...
    # be sure to change yourhomedirectory to the result of 
    cd ~
    pwd
    # remember to start/stop MAMP when all setup
    
    #
    # Virtual Hosts
    #
    NameVirtualHost *:8888
    
    <VirtualHost *:8888>
    	DocumentRoot /Users/home/Sites/htdocs
    	ServerName localhost
    </VirtualHost>
    
    <VirtualHost *:8888> 
      <Directory /Users/yourhomedirectory/Sites/htdocs/simplephpskinner> 
        AllowOverride All 
      </Directory> 
      DocumentRoot /Users/yourhomedirectory/Sites/htdocs/simplephpskinner
      ServerName mysite.local
    </VirtualHost>
    
    */
    require_once($_SERVER['DOCUMENT_ROOT'].'/includes/config.php');
    // arg "Home" appends page title, "home" is id for body, site is owner
    $template = new pageTemplate("Home","home","/",$site);
    $template->description = "yada yada";
    require_once($root.'/includes/head.phtml');
    require_once($root.'/includes/body_top.phtml');
    require_once($root.'/includes/topnav.phtml');	
    ?>
    <div id="leader" class="full-16">
    <!-- content here -->
    </div>
    <?php
    require_once($root.'/includes/footer.phtml');	
    require_once($root.'/includes/body_bottom.phtml');	
    ?>
    

### includes/footer.phtml

    
    
    <div id="footer">
    	<p class="quarter">&copy; 2010 <?php echo $template->owner ?></p>
    	<div class="threeQuarter" id="nav">
    		<a href="/">Home</a> |
    	</div>
    	<br class="clearLeft" />
    </div>
    

### includes/body_bottom.phtml

    
    
    <a href="#mainContent" class="accessibility">&#x2191; Back to page content</a>
    <a href="#mainMenu" class="accessibility">&#x2191; Back to main menu</a>
    	<!-- <div class="test">&nbsp;</div> -->
    </div><!--/#wrapper-->
    <?php echo $template->script("js/tail.js"); ?>
    <?php # require_once($root.'/includes/tracking.phtml'); ?>
    </body>
    </html><!-- <?php echo(date("D F d Y",time())); ?> -->
    

### includes/tracking.phtml

    
    
    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '<?php echo $googleAnalytics ?>']);
      _gaq.push(['_trackPageview']);
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
    

### js/jquery.plugins.js

    
    
    /**
     * jQuery go in here plugins.
     */
    

### js/tail.js

    
    
    /* load at end of page */
    $(document).ready(function() { 
    
    }); // end doc ready
    
