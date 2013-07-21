# ROROA CMS

Put simply Roroacms is a content management system built on Ruby on Rails. Roroacms started out as a project to learn more about the ins & outs of Ruby on Rails and seemlessly evolved to grow into a fully grown CMS, its a simple application that is fully extendible.

One thing to note about Roroacms is that it's media area is fully integrated with Amazon S3 at the moment so before you start head over to [http://aws.amazon.com/s3/](http://aws.amazon.com/s3/ "Amazon S3") and create a Amazon s3 account. The good thing about this is that it is FREE.

This documentation is a quick skim of what can be done with Roroa I will be working on the documentation over the next few months. But in the meantime if you have any problems please email me.

## A Demo

For a demo of Roroacms head over to demo.roroacms.com

To get into the admin panel use the details below:-

> Url:- demo.roroacms.com/admin

> Username:- demo

> Password:- demo

## Installation & Documentation 

Installation is really simple just follow the steps below to get started. Please make sure that ruby on rails is installed before you follow these steps.

1.  Download the zip file
2.  Upload the application to the server.
3.  Navigate to the project via the console.
4.  Run 'bundle install'
5.	Create database.yml and config.yml files in the config directory. (You will see examples of these files in the config directory)
6.	Run rake db:setup (You need to make sure the config files exist for it to run properly)
7.	YOUR DONE! All you need to do is navigate to /admin to get to the admin panel.

Please see below the settings for the individual configuration files.


## Config settings

The database.yml file is just the general database configuration file. We suggest that you use MYSQL as your choosen database adapter, however as it is all run with rails it should be fully extendible to all types of adapter.

##### config.yml settings 

All of the following settings have to be included in the config.yml file.

> **email_address**: email address used to send out notifications

> **domain**: Website domain

> **password**: email address password

> **articles_slug**: example (blog, news)

> **category_slug**: example (category, cat)

> **site_url**: actual website domain (http://www.example.co.uk/)

> **site_title**: website page title (this is the title)

> **display_url**: visual website domain (http://www.example.co.uk/)

> **tag_slug**: example (category, cat)

> **admin_email**: primary address for the software to send you notifcations(example@example.com)

> **admin_password**: primary admin password

> **admin_username**: primary admin username

> **aws_access_key_id**: example(AKIAI4VD2NT6NMGJLCOQ)

> **aws_secret_access_key**: example(j7b4LQuOW3s5BEUUR4yCujWyENYteiLsKL++x+h4)

> **aws_bucket_name**: example(roroa)

> **theme_folder**: example(roroa1)

## Theming

*Setting up a theme*

Theming in Roroacms is very simple simply create a theme folder in app > views > theme and away you go. You are able to have mulitple themes stored at any one time so you can update or completely redesign a theme you can keep the old one on the server. 

In order for your theme to be recognised by Roroa you need to include a theme.yml file in the root of your theme, the file needs to contain the following details:-

> **name**: The name of the theme

> **author**: Author of the theme

> **description**: The description of the theme

> **version**: Version no.

> **foldername**: The name of the folder on the server that the theme is contained in for example(roroa1)

Please note that all these options are required even if you leave them blank. You need to make sure that you contain the name and foldername in order for the theme to work.

------------------

*File Structure*

To get started on theming I would take the file structure of a current roroa theme(roroa1). This contains all the files that you can use in your theme. All of the files are required except:-

* template-*.html.erb - these are for customisable pages(The option to use these is avalible in the admin panel > pages > edit section)
* _sidebar.html.erb - You can include partials in your theme at any point by using the RoR standard way of including a partial.

In order to add assets like css, images, javascript files. You will need to navigate to app > assets, this will then display 

> app > assets > images > theme

> app > assets > javascripts > theme

> app > assets >stylesheets > theme 

You will then need to include a folder specific for the theme and include application.js which includes all the files within the directory. Once you have done this you will need to reference it correctly in the header of the layout for the css and javascript files:- 

> <%= stylesheet_link_tag "theme/**roroa1**/application", :media => "all" %>

> <%= javascript_include_tag 'theme/**roroa1**/application' %>

From there you simply need to navigate into the public folder and start creating the files that you will need to be included with your theme.

## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Simon Fletcher](https://github.com/fletcher890)

Icons from [Font Awesome](http://fortawesome.github.io/Font-Awesome/)