class TTYRenderer
  def render(game_state : GameState)
    world = game_state.world
    entities = world.entities.values

    puts "+" * (world.width + 2)

    (0..(world.height - 1)).each do |y|
      print '+'

      (0..(world.width - 1)).each do |x|
        entity = entities.find { |entity| entity.x == x && entity.y == y }

        if entity
          print entity.to_s
        else
          print " "
        end
      end

      print '+'
      print "\n"
    end

    puts "+" * (world.width + 2)
    puts
  end
end
