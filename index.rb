require 'bundler'
Bundler.require
require 'patterns'

get "/" do
  erb :main
end

get "/colophon" do
  erb :colophon
end

post "/pattern" do
  # params = { :name => GLIDER, :width => 3, :height => 3, :category => MOVER}
  category = Category.first(:name => params[:category])
  pattern = category.patterns.create :name => params[:name], :width => params[:width], :height => params[:height], :cells => params[:cells], :category => category
  pattern.save
  category.save
  
  # redirect "/category"
end

get "/pattern" do
  @categories = Category.all
  erb :newpattern
end

get "/category" do
  @allcategories = Category.all
  erb :categories
end

get "/category/new" do
  erb :newcategory
end

post "/category" do
  @category = Category.create(params)
  @allcategories = Category.all
  erb :categories
end