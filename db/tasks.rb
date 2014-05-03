module MigrationHelper
  require 'sequel'
  Sequel.extension :migration

  require 'dotenv'
  Dotenv.load

  DATABASE_URL = ENV.fetch('DATABASE_URL')

  def database
    @database ||= Sequel.connect(DATABASE_URL)
  end

  def db_name
    @db_name ||= begin
      require 'uri'
      URI(DATABASE_URL).path.gsub('/', '')
    end
  end

  def db_version
    database.tables.include?(:schema_info) ? database[:schema_info].first[:version].to_i : 0
  end

  def migrate_db(version = nil)
    if version
      puts "Migrating to version #{version}"
      Sequel::Migrator.run(database, "db/migrations", target: version.to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(database, "db/migrations")
    end
    self
  end

  def generate_migration(name)
    raise 'Must pass name: rake g:migration[add_index_to_table]' unless name
    next_version = format('%03d', db_version + 1)
    path = "db/migrations/#{next_version}_#{name}.rb"
    puts "Generating #{path}"
    File.write(path, MIGRATION_TEMPLATE)
    self
  end

  def create_db
    res = `createdb #{db_name} -w`
    raise res if /ERROR/ === res
    self
  end

  def drop_db
    res = `dropdb #{db_name}`
    raise res if /ERROR/ === res
    self
  end

  def rollback_db(version = nil)
    previous_version = version || db_version - 1
    migrate_db(previous_version)
    self
  end

  def console
    require './db/config'
    require 'irb'
    ARGV.clear
    IRB.start
  end

  MIGRATION_TEMPLATE = <<-TEMPLATE
Sequel.migration do
  up do
  end

  down do
  end
end
TEMPLATE
end

include MigrationHelper

namespace :db do
  task :reset do
    drop_db.create_db.migrate_db
  end

  task :drop do
    drop_db
  end

  task :create do
    create_db
  end

  task :migrate, [:version] do |t, args|
    migrate_db(args[:version])
  end

  task :rollback, [:version] do |t, args|
    rollback_db(args[:version])
  end

  task :console do
    console
  end
end

namespace :g do
  task :migration, [:name] do |t, args|
    generate_migration(args[:name])
  end
end
