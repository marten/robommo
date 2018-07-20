#!/usr/bin/env ruby
#
require "json"

input = JSON.parse(STDIN)

if input["age"].as_i % 2 == 0
  puts "move_north"
else
  puts "ranged_west"
end
