#!/usr/bin/env ruby

require 'json'

state = JSON.parse(STDIN.read)
actions = []


puts JSON.dump({actions: actions})
