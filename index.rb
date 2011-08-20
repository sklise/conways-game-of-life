require 'bundler'
Bundler.require

DataMapper.setup(:default, ENV['DATABASE_URL'] ||  'sqlite:///Users/sklise/Sites/ConwaysGameOfLife/db/dbconway.db')
Dir['app/*.rb'].each {|file| require file}
Dir['app/*/*.rb'].each {|file| require file}

configure do |c|
  set :views, Proc.new{ File.join(root, "app/views")}
end