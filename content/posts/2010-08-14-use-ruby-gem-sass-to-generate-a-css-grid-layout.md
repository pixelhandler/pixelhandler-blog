---
title: Use Ruby Gem, Sass to Generate a CSS Grid Layout
slug: use-ruby-gem-sass-to-generate-a-css-grid-layout
published_at: '2010-08-14'
author: pixelhandler
tags: []
meta_description: |-
  This is a basic template tool for generating your own grid system using Sass,
  and builds on best practices of existing CSS grid systems like 960.gs or
  Bluepr...
---

## In your grid.sass file:

Grid CSS as SASS (grid.sass) [download](/downloads/code/sass/grid.sass)

    
    // Grid 
    // =========================== 
    // e.g. 960px, 12 columns (px) : | 10+ | 60 + 20 (x11) | 60 + 10 | 
    
    // Setup your grid ...
    // total page width
    !gTotal = 960px
    // number of columns
    !grid = 16
    // gutter between columns
    !gGutter = 20px
    // set margin at half of gutter	
    !gMargin = !gGutter / 2
    // single column width
    !gCol = ( !gTotal / !grid ) - !gGutter
    // assign gird values to variables for use with semantic #id's
    !col4 = ( !gCol * 4 ) + ( !gGutter * ( 4 - 1 ) )
    !col16 = ( !gCol * !grid) + ( !gGutter * ( !grid - 1 ) )
    
    // mixins
    =colWidth(!c)
      width = ( !gCol * !c ) + ( !gGutter * ( !c - 1 ) )
    =column
      display: inline
      float: left
      margin-right = !gMargin
      margin-left = !gMargin
    
    // simple example...
    // =========================== 
    .full, .wide
      clear: left
    .wide
      +colWidth(16)
    .full
      width = !col16
    .quarter, .half, .threeQuarter
      float: left
    .quarter
      width = !col4
    .half
      width = !col4 * 2
    .threeQuarter
      width = !col4 * 3
    
    // design or prototype use...
    // =========================== 
    =gridTest
      background: #ccc
      margin-bottom: .5em
      margin-top: .5em
      min-height: 80px
    .col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col-13, .col-14, .col-15, .col-16
      +column
      +gridTest
    .col-16
      background-color: transparent
    // loop to create column widths
    @for !i from 1 through 12
      .col-#{!i}
        +colWidth(!i)
        //width = ( !gCol * !i ) + ( !gGutter * ( !i - 1 ) )
    .full-16
      margin: 0 auto
      width = !gTotal
    @for !i from 1 through 4
      .push-#{!i}
        margin-left = ( !gCol + !gMargin ) * !i
    @for !i from 1 through 4
      .pull-#{!i}
        margin-left = 0 - ( !i * ( !gCol + !gMargin ) )
    
    // helpers
    .container
      margin-right = 0
      margin-left = 0
    .first
      clear: left
      margin-left: 0
    .last
      margin-right: 0
    .indentLeft
      margin-left = !gMargin * 2
    .indentRight
      margin-right = !gMargin * 2
    .extend
      margin-right: 0
      margin-left: 0
      padding-left = !gMargin * 2
      padding-right = !gMargin * 2
    

### Execute on the command line

    
    
    # turns ruby into CSS
    sass grid.sass grid.css
    
    # check it out with textmate
    mate grid.css
    

this is part of my
[SimpleSassFramework](http://github.com/pixelhandler/simpleSassFramework) for
generating a boilerplate html site. See the CSS output… Grid SASS output
(grid.css)
    
    .full, .wide {
      clear: left; }
    
    .wide {
      width: 940px; }
    
    .full {
      width: 940px; }
    
    .quarter, .half, .threeQuarter {
      float: left; }
    
    .quarter {
      width: 220px; }
    
    .half {
      width: 440px; }
    
    .threeQuarter {
      width: 660px; }
    
    .col-1, .col-2, .col-3, .col-4, .col-5, .col-6, .col-7, .col-8, .col-9, .col-10, .col-11, .col-12, .col-13, .col-14, .col-15, .col-16 {
      display: inline;
      float: left;
      margin-right: 10px;
      margin-left: 10px;
      background: #ccc;
      margin-bottom: .5em;
      margin-top: .5em;
      min-height: 80px; }
    
    .col-16 {
      background-color: transparent; }
    
    .col-1 {
      width: 40px; }
    
    .col-2 {
      width: 100px; }
    
    .col-3 {
      width: 160px; }
    
    .col-4 {
      width: 220px; }
    
    .col-5 {
      width: 280px; }
    
    .col-6 {
      width: 340px; }
    
    .col-7 {
      width: 400px; }
    
    .col-8 {
      width: 460px; }
    
    .col-9 {
      width: 520px; }
    
    .col-10 {
      width: 580px; }
    
    .col-11 {
      width: 640px; }
    
    .col-12 {
      width: 700px; }
    
    .full-16 {
      margin: 0 auto;
      width: 960px; }
    
    .push-1 {
      margin-left: 50px; }
    
    .push-2 {
      margin-left: 100px; }
    
    .push-3 {
      margin-left: 150px; }
    
    .push-4 {
      margin-left: 200px; }
    
    .pull-1 {
      margin-left: -50px; }
    
    .pull-2 {
      margin-left: -100px; }
    
    .pull-3 {
      margin-left: -150px; }
    
    .pull-4 {
      margin-left: -200px; }
    
    .container {
      margin-right: 0;
      margin-left: 0; }
    
    .first {
      clear: left;
      margin-left: 0; }
    
    .last {
      margin-right: 0; }
    
    .indentLeft {
      margin-left: 20px; }
    
    .indentRight {
      margin-right: 20px; }
    
    .extend {
      margin-right: 0;
      margin-left: 0;
      padding-left: 20px;
      padding-right: 20px; }
    
