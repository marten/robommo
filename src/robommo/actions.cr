require "json"

abstract class Action
  def self.from(string)
    case string
    when "nothing"
      Action::Nothing
    when "move_north"
      Action::MoveNorth
    when "move_east"
      Action::MoveEast
    when "move_south"
      Action::MoveSouth
    when "move_west"
      Action::MoveWest
    when "duck"
      Action::Duck
    else
      Action::Nothing
    end
  end

  def initialize(@entity : Entity)
  end

  def entity
    @entity
  end

  abstract def act(world)

  class Nothing < Action
    def act(world)
      return world
    end
  end

  class MoveNorth < Action
    # TODO: bounds checking, collision checking, etc
    def act(world)
      next_entity = entity.update({y: entity.y - 1})
      world = world.update_entity(next_entity)
      return world
    end
  end

  class MoveEast < Action
    # TODO: bounds checking, collision checking, etc
    def act(world)
      next_entity = entity.update({x: entity.x + 1})
      world = world.update_entity(next_entity)
      return world
    end
  end

  class MoveSouth < Action
    # TODO: bounds checking, collision checking, etc
    def act(world)
      next_entity = entity.update({y: entity.y + 1})
      world = world.update_entity(next_entity)
      return world
    end
  end

  class MoveWest < Action
    # TODO: bounds checking, collision checking, etc
    def act(world)
      next_entity = entity.update({x: entity.x - 1})
      world = world.update_entity(next_entity)
      return world
    end
  end

  class Duck < Action
    def act(world)
      next_entity = entity.update({ducked: true})
      world = world.update_entity(next_entity)
      return world
    end
  end
end

