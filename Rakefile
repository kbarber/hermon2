# frozen_string_literal: true

require 'logger'

default_url = 'postgres://postgres:postgres@localhost/postgres'
DB_URL = ENV.key?('DATABASE_URL') ? ENV['DATABASE_URL'] : default_url

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_, args|
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(DB_URL) do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version, logger: Logger.new($stdout))
    end
  end
end
