DataMapper.setup(:default, ENV['DATABASE_URL'] ||  'sqlite:///Users/sklise/Sites/ConwaysGameOfLife/dbconway.db')

class Pattern
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :width,    Integer
  property :height,   Integer
  property :cells,    String
  
  belongs_to :category
  
  def handle_upload( file )
    thefile = file[:tempfile]
    filename = self.name.downcase+".png"
    # Upload to amazon
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAJDCZ3DW6AZVOP62A", :secret_access_key => "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")
    AWS::S3::S3Object.store(filename, open(thefile), "conways", :access => :public_read)
  end
end

class Category
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String
  property :description,  String
  
  has n, :patterns
end