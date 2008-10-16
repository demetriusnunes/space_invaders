class Sprite
  
  attr_reader :name, :image, :x, :y, :z, :world
  
  def initialize(world, name, x, y, z, alt_filename = nil)
    @world = world
    @name = name
    @alt_filename = alt_filename
    @x, @y, @z = x, y, z
    @world.add(self)
    @image = create_image
  end

  def born
  end
  
  def die
    @world.remove(@name)
  end
  
  def draw
    @image.draw(@x, @y, @z)
  end

  def update
  end
  
  def width
    @image.width
  end
  
  def height
    @image.height
  end
  
  private 
  def create_image
    Gosu::Image.new(@world.window, File.join(File.dirname(__FILE__), "..", "media", "#{@alt_filename || @name}.png"))
  end
end