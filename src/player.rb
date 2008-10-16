class Player < Sprite
  extend Publisher
  can_fire :destroyed

  def go_left
    @x -= 5 unless on_left_edge?
  end
  
  def go_right
    @x += 5 unless on_right_edge?
  end
  
  def shoot
    if cannon_charged?
      @last_fire = now
      Bullet.new(@world, "bullet#{rand}", @x + @image.width / 2, @y - 1, 1)
    end
  end
  
  def update
    move
  end
  
  def born
    @last_fire = 0
    fire_released
  end
  
  def die
    super
    fire :destroyed, self
  end

  def fire_released
    @fire_released = true
  end
  
  private
  def on_left_edge?
    @x <= 5
  end
  
  def on_right_edge?
    @x + @image.width >= @world.window.width - 5
  end
  
  def cannon_charged?
    200.milliseconds_since?(@last_fire)
  end
  
  def move
    if @world.window.button_down? Gosu::Button::KbLeft or 
       @world.window.button_down? Gosu::Button::GpLeft then
      go_left
    end
    if @world.window.button_down? Gosu::Button::KbRight or 
       @world.window.button_down? Gosu::Button::GpRight then
      go_right
    end
    
    if @fire_released and @world.window.fire_pressed? then
      @fire_released = false 
      shoot
    end
  end
  
end