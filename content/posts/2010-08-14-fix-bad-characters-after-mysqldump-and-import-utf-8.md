---
title: "Fix Bad Characters Ã¢â\x82¬ Ã\x82 After Mysqldump and Import Utf-8"
slug: fix-bad-characters-after-mysqldump-and-import-utf-8
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: Fix bad characters â€ Â after mysqldump and import
---

    
    mysqldump --default-character-set=latin1 --opt -h localhost -u
    export -p export > export.sql
    
    replace "CHARSET=latin1" "CHARSET=utf8" "SET NAMES latin1" "SET NAMES
    utf8" < export.sql > export-utf8.sql
    
    mysql --user=root -p --host=localhost --default-character-set=utf8
    cms_production < export-utf8.sql
    