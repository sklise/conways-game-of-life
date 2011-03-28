require 'bundler'
Bundler.require

get "/" do
  erb :main
end