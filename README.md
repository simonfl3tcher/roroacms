# ROROACMS

Roroacms is an Rails-based content management system which allows you to easily introduce a page and article management to your Rails 4 applications. Roroacms has come far over the years it started out as a project to learn more about the ins & outs of Ruby on Rails and seemlessly evolved to grow into a fully grown CMS. In this second release I have moved the CMS into an engine and given the system a complete make over visually and technically.

![GemVersion](https://badge.fury.io/rb/roroacms.png)

### Documentation & Demo 

I am currently working relentlessly on creating a good demo and documentation for Roroacms but I do not want to release them both until I am completely satified with them. For now however you are able to install the engine and check the admin panel out!


### Installing into a new Rails application

To get up and running with Roroacms in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

RoroaCMS works with Rails 4 onwards. To get up and running with RoroaCMS in a new Rails application just follow the instructions below and you'll be up and running in minutes:

```ruby
gem 'roroacms'
bundle install
rails generate roroacms:install
rake assets:clean
rake assets:precompile


rails new my_web
cd my_web
echo "gem 'roroacms'
bundle install
rails generate roroacms:install

If you want to go straight into production mode
RAILS_ENV=production rake assets:clean
RAILS_ENV=production rake assets:precompile

rails server
```

Once you start the server and visit the URL you will be presented with a installtion page which will walk you through setting the engine up fully.

### File Management

One thing to note about Roroacms is that it's media area is fully integrated with Amazon S3 at the moment so before you start head over to [http://aws.amazon.com/s3/](http://aws.amazon.com/s3/ "Amazon S3") and create a Amazon s3 account (Please make sure that the folder is open to the public).

alternatively if you are not interested in using the file manager you can leave the Amazon S3 config settings blank.

### Contribution

If you'd like to help with this project, please get in touch with me. The best place is on Twitter (@roroacms) or by e-mail to roroacms@gmail.com.

### License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012-2014 [Simon Fletcher](https://github.com/fletcher890)

Icons from [Font Awesome](http://fortawesome.github.io/Font-Awesome/)

### Other Information

Project homepage: [http://roroacms.co.uk](http://roroacms.co.uk)

Version: 1.0