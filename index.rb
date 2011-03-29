require 'bundler'
Bundler.require
//require 'patterns'

get "/" do
  erb :main
end

get "/colophon" do
  erb :colophon
end

# get "/patterns/new" do
#   @categories = Category.all
#   erb :newpattern
# end
# 
# post "/patterns/?" do
#   # params = { :name => GLIDER, :width => 3, :height => 3, :category => MOVER}
# end
# 
# get "/categories" do
#   @allcategories = Category.all
#   erb :categories
# end
# 
# get "/categories/new" do
#   erb :newcategory
# end
# 
# post "/add_category" do
#   @category = Category.create(params)
#   @allcategories = Category.all
#   erb :categories
# end