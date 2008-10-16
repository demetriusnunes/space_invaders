class Bomb < Sprite
  
  def initialize(world, name, x, y, z, alt_filename = nil)
    super
  end
  
  def update
    @y += 5
    die if @y > @world.window.height + 10
    
    if hit = @world.pick(@x, @y, Player)
      hit.die 
      self.die
    end
  end

  def draw
    @world.window.draw_quad(@x - 1, @y, 0xffff0000, 
                            @x - 1, @y - 20, 0xffff0000,
                            @x + 1, @y - 20, 0xffff0000,
                            @x + 1, @y, 0xffff0000)
  end

  def create_image
    nil
  end
  
end
