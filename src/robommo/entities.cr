require "json"
require "uuid"
require "uuid/json"
require "./scripts"
require "./actions"

abstract class Entity
  include JSON::Serializable
  include JSON::Serializable::Strict

  property id : UUID
  property coord : Coord

  def initialize(@id : UUID, @coord)
  end

  abstract def next_action(world : World) : Action
  abstract def to_s
end

class Player < Entity
  @[JSON::Field(ignore: true)]
  property script : Script

  property state

  def initialize(@id, @coord, script, @state = {health: 100, ducked: false})
    if script.is_a?(Script)
      @script = script
    else
      @script = Script.new(script)
    end
  end

  def next_action(game_state)
    action_class = @script.run(game_state)
    action_class.new(self)
  end

  def update(changes)
    next_coord = changes[:coord]? || @coord

    next_state = {
      health: changes[:health]? || @state[:health],
      ducked: changes[:ducked]? || @state[:ducked],
    }

    Player.new(@id, next_coord, @script, next_state)
  end

  def to_s
    if @state[:ducked]
      "_"
    else
      "T"
    end
  end
end
