#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'rufus-scheduler'
require 'sequel'

LOGGER = Logger.new($stdout)

LOGGER.info('Start')
DB_URL = 'postgres://postgres:postgres@localhost/postgres'
DB = Sequel.connect(DB_URL, logger: LOGGER)
UP = 1
DOWN = 2
SCHEDULE = '60s'

class State < Sequel::Model
  # TODO: has many
end

class Outage < Sequel::Model
end

def test_all
  State.all.each do |s|
    url = s[:url]
    LOGGER.info('URL ' + url + ' is being tested')

    begin
      PG::Connection.new(url, connect_timeout: 5)
      now = DateTime.now

      # UP
      LOGGER.info('URL ' + url + ' is up')
      if s[:state] == DOWN || s[:state].nil?
        LOGGER.info('Changing state')
        DB.transaction do
          Outage.insert(
            state_id: s[:id],
            start_time: s[:last_state_change],
            end_time: now)
          s.update(state: UP, last_state_change: now)
        end
      end
    rescue PG::ConnectionBad
      # DOWN
      LOGGER.info('URL ' + url + ' is down')
      if s[:state] == UP || s[:state].nil?
        LOGGER.info('Changing state')
        s.update(state: DOWN, last_state_change: DateTime.now)
      end
    end
  end
end

scheduler = Rufus::Scheduler.new

scheduler.every SCHEDULE do
  test_all
end
# TODO: remove this when we're running a web server
scheduler.join
