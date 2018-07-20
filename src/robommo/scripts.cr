require "json"
require "./entities"

class Script
  def initialize(cmd : String)
    @cmd = cmd
  end

  def run(state)
    puts "Calling #{@cmd} with #{state.to_json}"

    Process.run(@cmd) do |process|
      if !process.terminated?
        process.input.puts(state.to_json)
        process.input.close

        errors = process.error.gets_to_end

        if errors.empty?
          output = process.output.gets_to_end
          action = Action.from(output.strip)
          return action
        else
          puts "Errors: #{errors}"
          return Action.from("nothing")
        end
      else
        puts "Process crashed"
        return Action.from("nothing")
      end
    end

    return Action.from("nothing")
  end
end

