# Hermon

This tool provides you with the capability to monitor PostgreSQL
databases.

## Setup

First of all get the gems:

    bundle install

Then start a database:

    docker -p 5432:5432 -d postgres

Run the database migration to populate the DB with the schema:

    rake db:migrate

The start the application:

    ./app.rb

## Submitting a new test

You can submit a url to be tested using a HTTP POST:

    curl -X POST -H "Content-Type: application/json" -d '{"url":"postgres://username:password@hostname:5432/db"}' 'http://localhost:4567/dbs'

## Schema

* states
  * url - a connection URL for the database to be tested
  * last_state_changed - a timestamp for when the state last changed
  * state - 1 = UP, 2 = down
* outages
  * state_id - a foreign key to the state table
  * start_time - the start time for the outage
  * end_time - the end time for the outage
