require "./robommo/*"
require "json"

class GameState
  include JSON::Serializable
  
  property round : Int32

  def initialize(round)
    @round = round
  end
end

class ScriptActions
  include JSON::Serializable
  
  property actions : Array(Action)
end

class Action
  include JSON::Serializable
  
  property type : String
end

module Robommo
  class Script
    def initialize(cmd : String)
      @cmd = cmd
    end
      
    def run(state)
      Process.run(@cmd) do |process|
        if !process.terminated?
          process.input.puts(state.to_json)
          process.input.close
        
          errors = process.error.gets_to_end
          if errors.empty?
            response = process.output.gets_to_end
            puts "Actions: #{response}"
            ScriptActions.from_json(response)
          else
            puts "Errors: #{errors}"
          end
        else
          puts "Process crashed"  
        end
      end
    end
  end
end
  

script = Robommo::Script.new("bots/nothing.rb")

state = GameState.new(0)
actions = script.run(state)
