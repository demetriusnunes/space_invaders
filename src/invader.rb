class Invader < Sprite
  extend Publisher
  can_fire :destroyed, :reached_ground
  
  def initialize(world, name, x, y, z, alt_filename = nil)
    super
    @move_count = 0
  end
  
  def die
    super
    fire :destroyed, self
  end
  
  def go_left
    (@x -= 50; @move_count += 1) unless on_left_edge?
  end
  
  def go_right
    (@x += 50; @move_count += 1) unless on_right_edge?
  end

  def go_down
    @y += 50; @move_count += 1
    fire :reached_ground if @y + height > @world.window.height - 33
  end

  def draw
    current_image.draw(@x, @y, @z)
  end

  def width
    current_image.width
  end
  
  def height
    current_image.height
  end
  
  private 
  def create_image
    (1..4).to_a.map { |n| 
      Gosu::Image.new(@world.window, File.join(File.dirname(__FILE__), "..", "media", "#{@name.split('_').first}#{n}.png"))
    }
  end

  def current_image
    @image[@move_count % @image.size - 1]
  end
  
  def on_left_edge?
    @x <= 50
  end
  
  def on_right_edge?
    @x + @image.first.width >= @world.window.width - 50
  end
end