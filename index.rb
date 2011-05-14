require 'bundler'
Bundler.require
require 'patterns'
require 'lib/authorization'

helpers do
  include Sinatra::Authorization
end

get "/" do
  @allcategories = Category.all
  erb :main
end

get "/colophon" do
  erb :colophon
end

get "/pattern/new" do
  require_admin
  @categories = Category.all
  erb :newpattern
end

post "/pattern/new" do
  require_admin
  # params = { :name => GLIDER, :width => 3, :height => 3, :category => MOVER}
  category = Category.first(:name => params[:category])
  pattern = category.patterns.create :name => params[:name], :width => params[:width], :height => params[:height], :cells => params[:cells], :category => category
  pattern.handle_upload(params[:image])
  pattern.save
  category.save
  redirect "/category"
end

get "/pattern/:id" do
  content_type :json
  @pattern = Pattern.get(params[:id])
  pattern_json = {:name => @pattern.name, :width => @pattern.width.to_i, :height => @pattern.height.to_i, :shape => @pattern.cells}.to_json
  pattern_json
end

get "/category" do
  @allcategories = Category.all
  erb :allcategories
end

post "/category" do
  require_admin
  @category = Category.create(params)
  @allcategories = Category.all
  erb :allcategories
end

get "/category/new" do
  require_admin
  erb :newcategory
end

get "/category/:c" do
  @category = Category.first(:name => params[:c])
  erb :onecategory, :layout => false
end