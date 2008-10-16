#!/usr/bin/env ruby
[ 'src', 'lib' ].each { |dir| $LOAD_PATH << File.join(File.dirname(__FILE__), dir) }
 
require 'rubygems'
require 'gosu'
require 'publisher'
require 'utils'
require 'world'
require 'sprite'
require 'player'
require 'bullet'
require 'invaders_coordinator'
require 'invader'
require 'bomb'
require 'star'

class GameWindow < Gosu::Window

  HISCORE_FILE = 'hiscore.dat'
  WIDTH = 1024
  HEIGHT = 768
  INVADERS = { :satellite => 25, 
               :bug => 20, 
               :flyingsaucer => 15, 
               :spaceship => 10, 
               :star => 5 }
    
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Space Invaders"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 32)
    @high_score = open(HISCORE_FILE).read.to_i rescue 10000
    new_game
  end
  
  def update
    unless @game_over
      create_player if player_dead? && 
                       1000.milliseconds_since?(@time_of_death) &&
                       @lives > 0
      
      @invaders_coordinator.update
      @world.update
    else
      new_game if fire_pressed? && 2000.milliseconds_since?(@game_end_time)
    end
  end

  def draw
    @world.draw
    @font.draw("Wave #{@level}", 10, 10, 0)
    @font.draw("HIGH %06d" % @high_score, 200, 10, 0, 1, 1, 0xff0000ff)
    @font.draw("SCORE %06d" % @score, 600, 10, 0, 1, 1, 0xff0000ff)
    @font.draw("GAME OVER", 80, HEIGHT / 2 - 80, 0, 5, 5, 0xffff0000) if @game_over
    (1..@lives).to_a.each { |n|
      @player.image.draw(900 + n * 32, 16, 0, 0.5, 0.5)
    }
  end

  def fire_pressed?
    (button_down? Gosu::Button::KbSpace or button_down? Gosu::Button::GpButton0)
  end
  
  def button_up(id)
    @player.fire_released if id == Gosu::Button::KbSpace or id == Gosu::Button::GpButton0
    exit if id == Gosu::Button::KbEscape
  end
  
  private

  def new_game
    @world = World.new(self)
    @level = 0
    @score = 0
    @lives = 3
    @game_over = false
    create_stars
    new_level
    create_player
  end
  
  def new_level
    @level += 1
    @invaders_coordinator = InvadersCoordinator.new(@world, @level)
    create_invaders
  end
  
  def end_game
    @game_over = true
    @game_end_time = now
    open(HISCORE_FILE, "w") { |file| file.puts @high_score }
  end
  
  def invader_destroyed(sprite)
    type = sprite.name.split("_").first
    @score += INVADERS[type.to_sym] * @level
    @high_score = @score if @score >= @high_score
    new_level if @invaders_coordinator.invaders_remaining.size == 0
  end
  
  def player_destroyed
    @time_of_death = now
    end_game if @lives == 0
  end
  
  def player_dead?
    !@time_of_death.nil?
  end
  
  def create_player
    @lives -= 1
    @time_of_death = nil
    @player = Player.new(@world, :player, middle_pos(WIDTH, 54), HEIGHT - 33, 0)
    @player.when(:destroyed) { player_destroyed }
  end

  def create_invaders
    first_col = WIDTH / 2 - (6 * 100) / 2 + 27
    INVADERS.keys.each_with_index { |invader, row|
      (0..5).to_a.each { |col|
        inv = Invader.new(@world, "#{invader}_#{col}", (col * 100) + first_col, (row+1) * 80, 0)
        inv.when(:destroyed) { |dead| invader_destroyed(dead) }
        inv.when(:reached_ground) { end_game }
      }
    }
  end

  def create_stars
    qty = (WIDTH.to_f * HEIGHT.to_f * 0.0004).to_i
    qty.times { Star.new(@world) }
  end
  
  def middle_pos(canvas_size, object_size)
    ((canvas_size.to_f / 2.0) - (object_size.to_f / 2.0)).to_i
  end
end

window = GameWindow.new
window.show  