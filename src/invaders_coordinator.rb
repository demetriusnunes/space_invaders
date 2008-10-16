class InvadersCoordinator

  def initialize(world, level)
    @world = world
    @level = level
    @interval_floor = 100 - @level * 5
    @interval_factor = 20 - @level
    @last_invader_move = 0
    @invader_direction = :left
    @bomb_frequency = @level * 2 + 10
  end
  
  def update
    invaders = invaders_remaining
    move(invaders)
    drop_bomb(invaders.pick)
  end
  
  def move(invaders)
    interval = invaders.size * @interval_factor + @interval_floor
    if interval.milliseconds_since?(@last_invader_move)
      @last_invader_move = now
      if invaders.any? { |invader| invader.send("on_#{@invader_direction}_edge?") }
        @invader_direction = (@invader_direction == :left) ? :right : :left 
        invaders.each { |invader| invader.go_down }
      else
        invaders.each { |invader| invader.send("go_#{@invader_direction}") }
      end
    end
  end

  def drop_bomb(invader)
    if rand(1000) < @bomb_frequency
      Bomb.new(@world, "bomb#{rand}", 
                invader.x + invader.width / 2, 
                invader.y + invader.height + 1, 
                1)
    end
  end
  
  def invaders_remaining
    @world.select_all(Invader)
  end
end