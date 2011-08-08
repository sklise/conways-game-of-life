require 'bundler'
Bundler.require
require 'models'

get "/" do
  @allcategories = Category.all
  erb :main
end

get "/category" do
  @allcategories = Category.all
  erb :allcategories
end

get "/category/create" do
  erb :newcategory
end

post "/category/new" do
  @category = Category.create(params)
  @allcategories = Category.all
  erb :allcategories
end

get "/category/:category_name" do
  @category = Category.first(:name => params[:category_name])
  erb :onecategory, :layout => false
end

get "/colophon" do
  erb :colophon
end

get "/pattern/new" do
  @categories = Category.all
  erb :newpattern
end

post "/pattern/new" do
  category = Category.first(:name => params[:category])
  pattern = category.patterns.create(:name => params[:name].lowercase, :width => params[:width], :height => params[:height], :cells => params[:cells], :category_id => category)
  pattern.save
  category.save
  redirect "/category"
end

get "/pattern/:id" do
  content_type :json
  @pattern = Pattern.get(params[:id])
  pattern_json = {:name => @pattern.name, :width => @pattern.width.to_i, :height => @pattern.height.to_i, :shape => @pattern.cells, :draw => @pattern.draw}.to_json
  pattern_json
end