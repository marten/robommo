class Coord
  include JSON::Serializable

  getter x : Int32
  getter y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def inside?(world)
    @x >= 0 && @x < world.width && @y >= 0 && @y < world.height
  end

  def north
    Coord.new(@x, @y - 1)
  end

  def east
    Coord.new(@x + 1, @y)
  end

  def south
    Coord.new(@x, @y + 1)
  end

  def west
    Coord.new(@x - 1, @y)
  end
end
