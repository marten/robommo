require "./robommo/*"
require "json"
require "uuid"

class World
  include JSON::Serializable
  
  property width : Int32
  property height : Int32
  property entities : Hash(UUID, Entity)
  
  def initialize(@width, @height, @entities = {} of UUID => Entity)
  end
  
  def spawn(row_idx, col_idx, script)
    id = UUID.random
    @entities[id] = Player.new(id, row_idx, col_idx, script)
  end

  def update_entity(entity)
    next_entities = @entities.dup
    next_entities[entity.id] = entity
    return World.new(@width, @height, next_entities)
  end
  
  def step
    actions = collect_actions
    world = self

    actions.each do |action|
      world = action.act(world)
    end
    
    world
  end
  
  def collect_actions
    actions = [] of Action

    players.each do |player|
      action = player.next_action(self)
      actions << action
    end

    return actions
  end

  def players
    players = [] of Player

    @entities.each do |id, entity| 
      if entity.is_a?(Player)
        players << entity
      end
    end

    return players
  end
  
  def to_s
    @entities.map do |id, entity|
      entity.to_s
    end.join("\n")
  end
end

class GameState
  include JSON::Serializable
  
  property round : Int32
  property world : World

  def initialize(@round, @world)
    @round = round
    @world = world
  end
  
  def step
    GameState.new(round + 1, world.step)
  end
end


world = World.new(5, 5)
world.spawn(1, 1, "bots/nothing.rb")
world.spawn(3, 3, "bots/simple.rb")

renderer = TTYRenderer.new

state = GameState.new(0, world)
renderer.render(state)

puts "---"

state = state.step
renderer.render(state)

puts state.world.pretty_inspect
