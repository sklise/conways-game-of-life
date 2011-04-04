require 'bundler'
Bundler.require
require 'patterns'
require 'lib/authorization'

helpers do
  include Sinatra::Authorization
end

get "/" do
  erb :main
end

get "/colophon" do
  erb :colophon
end

post "/pattern" do
  require_admin
  # params = { :name => GLIDER, :width => 3, :height => 3, :category => MOVER}
  category = Category.first(:name => params[:category])
  pattern = category.patterns.create :name => params[:name], :width => params[:width], :height => params[:height], :cells => params[:cells], :category => category
  pattern.handle_upload(params[:image])
  pattern.save
  category.save
end

get "/pattern" do
  require_admin
  @categories = Category.all
  erb :newpattern
end

get "/category" do
  @allcategories = Category.all
  erb :categories
end

get "/category/new" do
  require_admin
  erb :newcategory
end

post "/category" do
  require_admin
  @category = Category.create(params)
  @allcategories = Category.all
  erb :categories
end