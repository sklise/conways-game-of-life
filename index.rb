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

get "/seed" do
  erb :seed
end

post "/seed" do
  categories = [
    {:name => "oscillators", :description => "Stable forms that cycle through a finite set of states."},
    {:name => "still_lifes", :description => "Stable forms that are static."},
    {:name => "methuslahs", :description => "Stable forms that are static."},
    {:name => "movers", :description => "Forms that move in a repeating pattern through the grid."}
  ]

  oscillators = [
    {:name => "blinker", :width => 3, :height => 3, :cells => "0,1,0,0,1,0,0,1,0"}
  ]
  
  still_lifes = [
    {:name => "tub", :width => 3, :height => 3, :cells => "0,1,0,1,0,1,0,1,0"}
  ]
  
  methuselahs = [
    {:name => "r-pentomino", :width => 3, :height => 3, :cells => "0,1,1,1,1,0,0,1,0"}
  ]
  
  movers = [
    {:name => "glider", :width => 3, :height => 3, :cells => "0,1,0,0,0,1,1,1,1"}
  ]
  
  categories.each do |category|
    newModel = Category.new(category)
    newModel.save
  end
  
  osc = Category.first(:name => "oscillators")
  sti = Category.first(:name => "still_lifes")
  met = Category.first(:name => "methuselahs")
  mov = Category.first(:name => "movers")
  
  oscillators.each do |pattern|
    newPattern = osc.patterns.create(pattern)
    newPattern.category_id = osc.id
    newPattern.save
  end
  
  still_lifes.each do |pattern|
    newPattern = sti.patterns.create(pattern)
    newPattern.category_id = sti.id
    newPattern.save
  end
  
  methuselahs.each do |pattern|
    newPattern = met.patterns.create(pattern)
    newPattern.category_id = met.id
    newPattern.save
  end
  
  movers.each do |pattern|
    newPattern = mov.patterns.create(pattern)
    newPattern.category_id = mov.id
    newPattern.save
  end
end