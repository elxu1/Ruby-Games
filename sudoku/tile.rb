require 'colorize'

class Tile
  attr_reader :value

  def initialize(value)
    @value = value
    @given = (value != 0)
  end

  def value= (new_value)
    @value = new_value if !@given
  end

  def to_s
    @given ? @value.to_s.colorize(:blue) : @value.to_s
  end
end