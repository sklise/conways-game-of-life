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

post "/category" do
  @category = Category.create(params)
  @allcategories = Category.all
  erb :allcategories
end

get "/category/new" do
  erb :newcategory
end

get "/category/:category_name" do
  @category = Category.first(:name => params[:category_name])
  erb :onecategory, :layout => false
end

get "/construction" do
  @allcategories = Category.all
  erb :construction
end

get "/colophon" do
  erb :colophon
end

get "/pattern/new" do
  @categories = Category.all
  erb :newpattern
end

post "/pattern/new" do
  raise params.inspect
  category = Category.first(:name => params[:category])
  pattern = category.patterns.create(:name => params[:name], :width => params[:width], :height => params[:height], :cells => params[:cells], :category => category)
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

get "/seed" do
  erb :seed
end

post "/seed" do
  categories = [
    {:name => "Oscillators", :description => "Stable forms that cycle through a finite set of states."},
    {:name => "Still Lifes", :description => "Stable forms that are static."},
    {:name => "Methuslahs", :description => "Stable forms that are static."},
    {:name => "Movers", :description => "Forms that move in a repeating pattern through the grid."}
  ]
  categories.each do |category|
    newModel = Category.new(category)
    newModel.save
  end
  
  "watch it now"
end