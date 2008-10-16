class Star < Sprite
  
  def initialize(world)
    @world = world
    @moved = 0
    @x = rand(@world.window.width)
    @y = rand(@world.window.height)
    @size = rand(3)
    @color = rand(0xffffffff)
    @name = "Star_#{x}_#{y}_#{@size}_#{@color}"
    @world.add(self)
  end
  
  def update
    if 10.milliseconds_since?(@moved)
      @moved = now
      @y = (@y + 2) % @world.window.height
    end
  end

  def draw
    @world.window.draw_quad(@x, @y, @color, 
                            @x, @y + @size, @color,
                            @x + @size, @y + @size, @color,
                            @x + @size, @y, @color)
  end

  def create_image
    nil
  end
  
end
