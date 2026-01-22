---
title: Scaffold for a browser app built with Ember.js, Rails, Ember.Data
slug: scaffold-for-a-browser-app-built-with-emberjs-rails-emberdata
published_at: '2013-09-24'
author: pixelhandler
tags:
- Ember.js
- Rails
- Data
meta_description: |-
  **Journal App**

  This is a scaffold for setting up: an API with Rails and the ember-rails gem, persistence with Ember.Data, and a browser app using Ember.js
  ...
---

## Setup Back-end

1)  Create the api application with rails


    rails new journal -d postgresql
    cd journal


2)  Create a migration for `Entry`


    rails g migration create_entries name:string

...

    class CreateEntries < ActiveRecord::Migration
      def change
        create_table :entries do |t|
          t.string :name
        end
      end
    end
    

3)  Configure db


    rake db:create
    rake db:migrate


4)  Create a model

In app/models/entry.rb


    class Entry < ActiveRecord::Base
    end


5)  Add a record


    rails console
    Entry.create name: "First entry in my journal app"
    Entry.all
    exit


Could have used seeds as well, see db/seeds.rb


    Entry.create([{ name: 'Using rails as an api' }, { name: 'Using Ember-data for persistence' }])

...

    rake db:seed


6)  Create a Serializer

In app/serializers/entry_serializer.rb


    class EntrySerializer < ActiveModel::Serializer
      attributes :id, :name
    end


7)  Update Gemfile

Remove `gem 'turbolinks'`, add:

    gem 'ember-rails'


8)  Remove turbolinks from application layout

In app/views/layouts/application.html.erb

    <!DOCTYPE html>
    <html>
    <head>
      <title>Journal</title>
      <%= stylesheet_link_tag "application", media: "all" %>
      <%= javascript_include_tag "application" %>
      <%= csrf_meta_tags %>
    </head>
    <body>


9)  Update configs

In environments/production.rb

    config.ember.variant = :production


In environments/development.rb

    config.ember.variant = :development


In environments/test.rb

    config.ember.variant = :development


10) Create controllers

In app/controllers/home_controller.rb

    class HomeController < ApplicationController
    end


In app/controllers/api/v1/entries_controller.rb

    class Api::V1::EntriesController < ApplicationController
      respond_to :json
    
      def index
        respond_with Entry.all
      end
    
      def show
        respond_with Entry.find(params[:id])
      end
    
      private
    
      def entry_params
        params.require(:entry).permit(:name)
      end
    end


11) Setup a namespace in routes.rb

In config/routes.rb

    Journal::Application.routes.draw do
      root to: 'home#index'
    
      namespace :api do
        namespace :v1 do
          resources :entries, only: [:index, :show]
        end
      end
    end


12) Add main `outlet` for ember content in `home#index` template

In app/views/home/index.erb

    <script type="text/x-handlebars">{{ outlet }}</script>

## Setup Front-end

1)  Generate the Ember app code using CoffeeScript

    rails g ember:bootstrap -g --javascript-engine coffee -n App


2)  Download Canary version of ember into `vendor` directory

See [ember canary builds].

    vendor/assets/javascripts/ember-data-canary.js
    vendor/assets/javascripts/ember-canary.js


[ember canary builds]: http://emberjs.com/builds/#/canary/latest

3)  Also add in jQuery-1.9.1 and Handlebars-1.0.0

Just grab from [emberjs/starter-kit]

[emberjs/starter-kit]: https://github.com/emberjs/starter-kit/tree/master/js/libs

4)  Update application.js for using Sprockets


    //= require jquery-1.9.1
    //= require jquery_ujs
    //= require handlebars-1.0.0
    //= require ember-canary
    //= require ember-data-canary
    //= require_self
    //= require app
    
    // for more details see: http://emberjs.com/guides/application/
    App = Ember.Application.create();
    
    //= require_tree .


5)  Create the Entry model

In app/assets/javascripts/models/entry.js.coffee

    App.Entry = DS.Model.extend
      name: DS.attr('string')


6)  Create a router

In app/assets/javascripts/router.js.coffee

    App.Router.map ()->
      @resource('entries')


See: [routing] guide

[routing]: http://emberjs.com/guides/routing/

7)  Create the Entry route

In app/assets/javascripts/routes/entries.js.coffee

    App.EntriesRoute = Ember.Route.extend
      model: ->
        @get('store').findAll 'entry'


8)  Setup the Store (persistence w/ ember-data)

In app/assets/javascripts/store.js.coffee

    App.ApplicationAdapter = DS.RESTAdapter.extend
      namespace: 'api/v1'
      #configure: 'plurals', entry: 'entries'


See [defining-a-store] guide.

[defining-a-store]: http://emberjs.com/guides/models/defining-a-store/

9)  Create a couple handlebars templates

In app/assets/javascripts/templates/entries.handlebars

    <h1>Entries...</h1>
    {{#each entry in controller}}
      {{render "entry" entry}}
    {{/each}}    

In app/assets/javascripts/templates/entry.handlebars

    <h2>{{name}}</h2>

## Fire up the app

Command to start server

    rails server


Try it out in your browser, visit:  

* <http://localhost:3000/#/entries>
* <http://localhost:3000/api/v1/entries.json>

### Credits:

Thanks to [Vic Ramon] for posting: [Setting up an Ember App with a Rails Backend]

[Vic Ramon]: http://hashrocket.com/team/vic-ramon
[Setting up an Ember App with a Rails Backend]: http://hashrocket.com/blog/posts/setting-up-an-ember-app-with-a-rails-backend