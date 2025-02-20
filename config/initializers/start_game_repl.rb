require_relative "../../lib/game_service/idgen"
require_relative "../../lib/game_service/room"
require_relative "../../lib/game_service/npc"
require_relative "../../lib/game_service/world"
require_relative "../../lib/game_service/object"
require_relative "../../lib/game_service/direction"
require_relative "../../app/helpers/application_helper"

# require_relative '../../world'
# require_relative 'object'
# require_relative 'room'
# require_relative 'command'
# require_relative 'direction'
# require_relative 'events'
# require_relative 'npc'

puts "DEBUG puts start_game_repl called"

ii = IdGenerator.new

id = ii.get
puts "id: #{id}"

id = ii.get
puts "id: #{id}"

puts "DEBUG puts start_game_repl called"


def init_world
  world = World.new
  ApplicationHelper.set_world(world)

  puts "DEBUG init_world 0"

  roomA = Room.new(world.new_id, "A small garden", "This garden isn't very large.", "The garden smells like wildflowers")
  roomB = Room.new(world.new_id, "A large kitchen", "This kitchen is quite large. Pots hang on the walls, and something smells good.", "The garden smells like wildflowers")

  world.link_rooms(roomA, Direction::EAST, roomB)

  player = world.make_player("rob", roomA) # TODO make users createable

  sword = Sword.new(world.new_id, "a short sword", "This is a very shiny sword.", 42)
  cup = Objectt.new(world.new_id, "cup", "an ornate silver cup", "This cup is very ornate and silver.")

  player.add_item(sword)
  player.add_item(cup)

  world_key = make_world_key(world)
  player.add_item(world_key)

  puts "DEBUG init_world 98"

  goblin = NPC.new(world.new_id, "goblin", "a pungent goblin", "This goblin is quite rank.", true)
  player.add_item(goblin)

  puts "DEBUG init_world 99"
end

init_world
