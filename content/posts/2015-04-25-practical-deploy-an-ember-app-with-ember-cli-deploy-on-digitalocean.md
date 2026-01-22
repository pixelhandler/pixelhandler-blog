---
title: 'Practical: Deploy an Ember App with ember-cli-deploy'
slug: practical-deploy-an-ember-app-with-ember-cli-deploy-on-digitalocean
published_at: '2015-04-25'
author: pixelhandler
tags:
- Ember.js
- Ember Addons
- Deployment
meta_description: The notes below demonstrate how to setup a chat application, built
  with [Ember CLI], that uses a backend service from [Firebase]. The example walks
  through t...
---

## Lightning-Approach Workflow
This approach is the default setup when using ember-cli-deploy and uses a Redis
store for the versions of your index.html file that you deploy. This strategy allows
for (pre)viewing any deployed version using an URL parameter.

For the application's asset files (CSS, JavaScript, images, etc) this workflow pushes
them to an S3 bucket.

Below is the documentation and includes a diagram of the approach:

* See [Documentation][lightning docs]

[lightning docs]: https://github.com/ember-cli/ember-cli-deploy#lightning-approach-workflow

## Deploy an App with ember-cli-deploy

[How to use]…

    ember deploy --environment production
    ember deploy:list --environment production

Pick a version to deploy

    ember deploy:activate --revision chat-app:XXXXXX --environment production

You can preview a version using the `index_key` parameter, like so
<http://chat.pixelhandler.com/?index_key=cde6f62> where the parameter represents a
commit hash that has been deployed (but may not be activated yet).

[How to use]: https://github.com/ember-cli/ember-cli-deploy#how-to-use


## Firebase

Create your own firebase account, [signup here](https://www.firebase.com/signup/).
Then your app will have a real-time backend. In your [app config] use your account url:

* Mine is: `https://pixelhandler.firebaseio.com/`
* I set the above URL in the config/environment.js file of my Ember app

[app config]: https://github.com/Ember-SC/ember-cli-screencast/blob/master/config/environment.js#L9

### Security & Rules

In your Firebase Application Dashboard, setup the rules for your data. The collection
that the application uses is `messages`.

    {
      "rules": {
        ".read": true,
        ".write":false,
        "messages":{
          ".read": true,
          ".write": true,
          ".indexOn": "timestamp"
        }
      }
    }

## Setup an Ubuntu box with DigitalOcean

[DigitalOcean] has excellent guides on using their hosting service. See this guide
which details the setup of an Ubuntu box:

* Guide: [Initial Server Setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04)


## Install Node.js

I recommend using [NVM], Node Version Managager, to install versions of Node.js

* See [NVM]
* Use [forever] to continuously run a Node.js app

[NVM]: https://github.com/creationix/nvm
[Node.js]: https://nodejs.org/
[forever]: https://github.com/foreverjs/forever

## Install Nginx

* Guide: [how-to-install](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts)

You may need to edit your [nginx] config file or perhaps view the logs…

[nginx]: http://nginx.org/en/

### Config

    sudo vim /etc/nginx/nginx.conf

### Logs

    tail -f /var/log/nginx/access.log
    sudo tail -f /var/log/nginx/error.log

### Restart

    sudo service nginx restart


## Install Redis

* Guide: [how-to-install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis)

See the [Redis] downloads page for the current version:

* <http://redis.io/download>

### Post Install Setup

Setup your redis server with a script…

    cd /usr/local/src/redis-3.0.0/utils
    sudo ./install_server.sh

I used port 6379 which setups up a config file at /etc/redis/6379.conf

### Config

Bind your IP address for the server your app runs on, mine is on `107.170.232.223`.

    vim /etc/redis/6379.conf

    bind 107.170.232.223 127.0.0.1
    requirepass yoursecretkeyshouldbeverylongyouknowredisisfastright

Notice in the config file that you are encouraged to use a long passwords

### Connecting

I'm using an environment variable for my redis password

    redis-cli -h pixelhandler.com -p 6379 -a $REDIS_SECRET

Or locally on the Ubuntu box:

    redis-cli -h 127.0.0.1 -p 6379

Then enter the `AUTH` command followed by your secret key

### Start/Stop

    sudo service redis_6379 start
    sudo service redis_6379 stop

### Show the keys

Once you deploy a version you can connect then list the keys that are stored:

    keys *

### Install Git

If not already installed setup your box to use [git]:

* Guide: [how-to-install](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-14-04)

[git]: http://git-scm.com


## AWS S3 Bucket

I created a bucket named `chat-app` to host the application assets: the `app` JS & CSS as well ass the contents of the `public` directory of the client application.

* My Endpoint: chat-app.s3-website-us-east-1.amazonaws.com

### Bucket Policy

I used the policy generator tool in AWS to setup a bucket policy for any
Web visitor to read the assets in the bucket for the chat-app:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowPublicRead",
          "Action": [
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::chat-app/*",
          "Principal": {
            "AWS": "*"
          }
        }
      ]
    }

I tested an upload of a simple index.html file to be sure the setup works, which will
get clobbered by the deployment anyway. The index.html file that gets pushed to the
bucket will not be used to serve the website.

### Bucket User

This is a good tutorial on configuring your S3 bucket for deploying
assets for your Ember application:

* Example setup: [deploy to s3](http://kerrygallagher.co.uk/deploying-an-ember-cli-application-to-amazon-s3/)

You'll need to setup an user that can write to your bucket, use the AWS console tools
to create new user for your S3 bucket:

* IAM policy, services -> IAM -> Create New Users
  * [AWS users]

You'll need to copy the access key and secret access key to use in your deployment
config for pushing assets to your S3 bucket.

User's *Inline Policy* for the bucket, notice that the bucket name is the same as
my app name:

    {
      "Statement": [
        {
          "Action": "s3:*",
          "Effect": "Allow",
          "Resource": [
            "arn:aws:s3:::chat-app",
            "arn:aws:s3:::chat-app/*"
          ]
        }
      ]
    }

### Environment Variables

The chat app's deployment script will use environment variables for:

* `AWS_ACCESS_KEY`, `AWS_SECRET_ACCESS_KEY`
* See [AWS users] for your user's access keys

[AWS users]: https://console.aws.amazon.com/iam/home#users


## Chat App

* Running at <http://chat.pixelhandler.com/>
* Source for server app: [ember-lightning](https://github.com/Ember-SC/ember-lightning)
* Source for client app: [ember-cli-screencast](https://github.com/Ember-SC/ember-cli-screencast)

Server app needs config setup in an `app.json` file, copy the [app.example.json]
on your box.

[app.example.json]: https://github.com/Ember-SC/ember-lightning/blob/master/app.example.json

Client app is using environment variables in the config/deploy.js file, I created a dot file that I source when running the `ember deploy` command. See deploy section above, which lists out the deployment commands.

Clone the example app and install the dependencies:

    git clone git@github.com:Ember-SC/ember-cli-screencast.git ./chat-app-client
    cd chat-app-client
    npm install
    bower install

Try out `ember server` locally and visit <http://localhost:4200>

If the app works get ready to deploy to your production box.

First setup your server with Node.js & Redis to try out your first deployment with
ember-cli-deploy. The following section explains the hosting setup for your
production server…

### Vhost Setup

Using nginx I setup a proxy to the port that the node application will run on.

* See: [host multiple node.js apps](https://www.digitalocean.com/community/tutorials/how-to-host-multiple-node-js-applications-on-a-single-vps-with-nginx-forever-and-crontab)

#### DNS

I used Amazon's Route 53 product for my DNS. So I added a subdomain on
my hosted zone:

    chat.pixelhandler.com.
    A
    107.170.232.223

#### Serve up the Index.html page

When using ember-cli-deploy-redis, versions of your app will have a key that
is a combination of your app name and the commit hash of the release.
Your Redis DB will store the various deployed versions of your index page.

See [ember-cli-deploy adapters](https://github.com/ember-cli/ember-cli-deploy#existing-custom-adapters) for existing index adapters

I setup a `www` directory in my home user, then used git to clone the
example [ember-lightning] app which connects to redis and serves up the
[index.html page in a node.js app][index.js]. The app also accepts an URL
query parameter to get the version of the index.html to send back to the browser.

See: [ember-lightning][ember-lightning fork]

    cd ~/www/
    git clone https://github.com/Ember-SC/ember-lightning ./chat-app-server
    cd ./chat-app-server

[ember-lightning fork]: https://github.com/Ember-SC/ember-lightning
[index.js]: https://github.com/Ember-SC/ember-lightning/blob/master/index.js

Run with forever…

    nvm use 0.12.2
    npm install
    forever start -c "node --harmony" -o ~/www/chat-app-server/out.log -e ~/www/chat-app-server/err.log --spinSleepTime 10000 --minUptime 10000 ~/www/chat-app-server/index.js >> ~/www/chat-app-server/out.log 2>&1

#### Nginx config for the chat-app

Create a conf file for your vhost, e.g. `/etc/nginx/conf.d/chat.pixelhandler.com.conf`

This uses a proxy pass to the IP and port that the node.js app runs on. I'm running
on port 8787.

    server {
      listen 80;

      server_name chat.pixelhandler.com;

      location / {
        proxy_pass http://107.170.232.223:8787;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
      }
    }

Restart nginx

    sudo service nginx restart


## Recap

I used an Ubuntu box to deploy a client Web applicaiton that uses Firebase as a
backend. These notes provide an exercise in learning to deploy an Ember.js
application built with Ember CLI.

* See the [screencast] on building the chat-app by [Sara Robinson] of [Firebase]
* My [fork of the source code][chat app fork]
* The server app the renders the current version and allows previewing
  other deployed versions: [ember-lightning fork]

[screencast]: https://www.firebase.com/blog/2015-03-13-ember-cli-in-9-minutes.html
[chat app fork]: https://github.com/Ember-SC/ember-cli-screencast

I chose a Node.js app to serve up the index.html page in anticipation of
the [FastBoot] addon to render an [Ember.js] app on the server.

[FastBoot]: https://github.com/tildeio/ember-cli-fastboot#ember-fastboot
[Ember.js]: http://emberjs.com

Consider using my referal link to sign up for [DigitalOcean] and try out
ember-cli-deploy yourself.

Some alternatives to setting up your own box are:

* <http://redistogo.com>
* <https://www.heroku.com/>

So if you what to chat about this article visit [chat.pixelhandler.com].

[chat.pixelhandler.com]: http://chat.pixelhandler.com
[DigitalOcean]: https://www.digitalocean.com/?refcode=906d4e66b348
[Ember CLI]: http://www.ember-cli.com
[ember-cli-deploy]: https://github.com/ember-cli/ember-cli-deploy
[Firebase]: https://www.firebase.com
[Redis]: http://redis.io
[Sara Robinson]: https://github.com/sararob