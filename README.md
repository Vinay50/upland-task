# README

*I have developed this web based Products listing application using Ruby on Rails with SQLite DB on MacOS operating system.

*I have used Rails version 6.1.6 and Ruby 2.7.0 to develope this application.

*I have complated below Issues.
    As a user I'd like to upload product.tab file and have the information about the products displayed in a simple table #1 
    As a user I'd like to sort the products by their names #2 
    As a user I'd like to filter the products by their category #3 
     

Note: 
To run this application, you need to install Ruby, node js and yarn installed on your machine
Ruby can installed using RVM.
This application code is on git@github.com:upland-india/vieenay_siingh_takehometest.git with master branch.


Steps to run Products list application

* Clone this application from git@github.com:upland-india/vieenay_siingh_takehometest.git

* To go master branch 

* bundle install #install all dependencies

* rake db:migrate # to create db and add table

* rake db:seed  # add basic data to product table

* bundle exec rake webpacker:install  # install webpacker

* rails s  #run rails app on your local machine
