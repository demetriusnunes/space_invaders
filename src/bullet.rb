class Bullet < Sprite
  
  def initialize(world, name, x, y, z, alt_filename = nil)
    super
  end
  
  def update
    @y -= 5
    die if @y < -10
    
    if hit = @world.pick(@x, @y, Invader)
      hit.die 
      self.die
    end
  end

  def draw
    @world.window.draw_quad(@x - 1, @y, 0xffffff00, 
                            @x - 1, @y - 20, 0xffffff00,
                            @x + 1, @y - 20, 0xffffff00,
                            @x + 1, @y, 0xffffff00)
  end

  def create_image
    nil
  end
  
end
