
class Pattern
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :category_id, Integer
  property :width,    Integer
  property :height,   Integer
  property :cells,    String
  
  belongs_to :category
end

class Category
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String
  property :description,  String
  
  has n, :patterns
end