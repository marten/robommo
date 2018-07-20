require "json"
require "uuid"
require "uuid/json"
require "./scripts"
require "./actions"

abstract class Entity
  include JSON::Serializable
  include JSON::Serializable::Strict

  property id : UUID
  property x : Int32
  property y : Int32

  def initialize(@id : UUID, @x, @y)
  end

  abstract def next_action(world : World) : Action
  abstract def to_s
end

class Player < Entity
  @[JSON::Field(ignore: true)]
  property script : Script

  def initialize(@id, @x, @y, script, @state = {health: 100, ducked: false})
    if script.is_a?(Script)
      @script = script
    else
      @script = Script.new(script)
    end
  end

  def next_action(world)
    action_class = @script.run(world)
    action_class.new(self)
  end

  def update(changes)
    next_x = changes[:x]? || @x
    next_y = changes[:y]? || @y
    next_state = {
      health: changes[:health]? || @state[:health],
      ducked: changes[:ducked]? || @state[:ducked]
    }

    Player.new(@id, next_x, next_y, @script, next_state)
  end

  def to_s
    if @state[:ducked]
      "_"
    else
      "T"
    end
  end
end

