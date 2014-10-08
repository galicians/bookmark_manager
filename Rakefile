require 'data_mapper'
require './lib/user'


env = ENV["RACK_ENV"] || "development"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  DataMapper.finalize

# env = ENV["RACK_ENV"] || "development"
# DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# DataMapper.finalize
puts 'im here'
task :auto_upgrade do
  # auto_upgrade makes non-destructive changes.
  # If your tables don't exist, they will be created
  # but if they do and you changed your schema
  # (e.g. changed the type of one of the properties)
  # they will not be upgraded because that'd lead to data loss.
  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do
  # To force the creation of all tables as they are
  # described in your models, even if this
  # may lead to data loss, use auto_migrate:
  puts "Auto-upgrade complete (no data loss)"
  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data could have been lost)"
end

task :pablo do
  env = ENV["RACK_ENV"] || "test"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
  puts "Auto-upgrade complete (no data loss)"
  DataMapper.auto_migrate!
  end
# Finally, don't forget that before you do any of that stuff,
# you need to create a database first.