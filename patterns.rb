DataMapper.setup(:default, ENV['DATABASE_URL'] ||  'sqlite:///Users/sklise/Sites/ConwaysGameOfLife/dbconway.db')
class Pattern
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :width,    Integer
  property :height,   Integer
  property :cells,    String
  property :image,    String
  
  belongs_to :category
end

class Category
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String
  property :description,  String
  
  has n, :patterns, :required => false
end

# DataMapper.auto_upgrade!
# DataMapper.auto_migrate!