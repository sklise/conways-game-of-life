DataMapper.setup(:default, ENV['DATABASE_URL'] ||  'sqlite:///Users/sklise/Sites/ConwaysGameOfLife/dbconway.db')

class Pattern
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :category_id, Integer
  property :width,    Integer
  property :height,   Integer
  property :cells,    String
  
  belongs_to :category
  
  def draw
    output = "<div class='width-#{self.width} height-#{self.height} pattern-drawing'>"
    @cells = self.cells.split(',')
    @cells.each do |cell|
      if(cell == "1")
        output += "<div class='on'></div>"
      else
        output += "<div class='off'></div>"
      end
    end
    output += "</div>"
    output
  end
end

class Category
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String
  property :description,  String
  
  has n, :patterns
end

# DataMapper.auto_upgrade!
# DataMapper.auto_migrate!