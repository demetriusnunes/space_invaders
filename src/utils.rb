def now
  Gosu::milliseconds
end

class Numeric
  def milliseconds_since?(event)
    now - event > self
  end
end

class Array
  
  def pick
    picked = rand(self.size)
    self[picked]
  end

end