# README

## Dependencies

* Ruby version 2.6.3
* PostgreSQL server

## Application run

* `git clone`
* `cd lottery && bundle install`
* tweak database.yml to change the user and db name if needed
* `bin/rake db:setup`
* `bower install`
* `bin/rails s`
* navigate to localhost:3000 in a browser
* enjoy

## Tests run

Run them by `bin/rails spec`