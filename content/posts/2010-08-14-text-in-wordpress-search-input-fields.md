---
title: Text in WordPress Search Input Fields
slug: text-in-wordpress-search-input-fields
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  Using jQuery to add the text 'Search' to the search input box in WordPress;
  when user enters text input to search the helper text is removed
---

```javascript
// set Search input to default text
$('#s').attr('value','Search');

// clear search input form
$('#s').focus(function(){
    $('#s').val('');
});
```