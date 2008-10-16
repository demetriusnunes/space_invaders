class World
  attr_reader :window, :sprites
  
  def initialize(window)
    @window = window
    @sprites = {}
  end
  
  def add(sprite)
    self[sprite.name] = sprite
    sprite.born
  end

  def remove(sprite_name)
    sprite = @sprites.delete(sprite_name)
  end
  
  def [](sprite)
    @sprites[sprite]
  end
  
  def []=(name, sprite)
    @sprites[name] = sprite
  end
  
  def draw
    @sprites.values.each { |sprite| sprite.draw }
  end
  
  def update
    @sprites.values.each { |sprite| sprite.update }
  end
  
  def select_all(klass)
    @sprites.values.select { |sprite| sprite.is_a? klass }
  end
  
  def pick(x, y, klass = Sprite)
    select_all(klass).select { |sprite| 
      x > sprite.x && 
      x < sprite.x + sprite.width &&  
      y > sprite.y && 
      y < sprite.y + sprite.height
    }.last
  end
  
end