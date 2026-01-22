---
title: OSX Upgrade to Lion Went Well, and So Far Native PHP and MySQL Server Playing
  Nice
slug: osx-upgrade-to-lion-went-well-and-so-far-native-php-and-mysql-server-playing-nice
published_at: '2011-07-21'
author: pixelhandler
tags: []
meta_description: |-
  Today I upgraded to Lion (was on Snow Leopard). My main concern was that the
  OSX (native) PHP would break and that MySQL server (community) installation
  woul...
---

So I...

  1. Ran Software Update,
  2. backed up with Time Machine,
  3. repaired disk permissions,
  4. and verified my disk.
  5. Then purchased Lion in the app store on my mac.
  6. Made a backup of my /private/etc/php.ini file
  7. Installed Lion
  8. Ran Software Update again, e.g. for Java updates
Next, I checked my localhost/phpmyadmin and checked my phpinfo.php files. The
article 'Fixing mysql in OS X Lion upgrade' (link above) was correct. I needed
to:

  1. Place my copy of php.ini back to its original location at /private/etc/php.ini
  2. Update the php.ini file to change mysqli setting… ;mysqli.default_socket = /var/mysql/mysql.sock mysqli.default_socket = /tmp/mysql.sock
My current LAMP dev projects seem just fine so far. Notes on localhost
environment on Lion :

  * mysql -version mysql  Ver 14.14 Distrib 5.5.12, for osx10.6 (i386) using readline 5.1
  * php -version PHP 5.3.6 with Suhosin-Patch (cli) (built: Jun 16 2011 22:26:57)
  * httpd -v Server version: Apache/2.2.19 (Unix)
