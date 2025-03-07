require_relative '../../app/helpers/application_helper'

require 'ruby-text-game'

puts 'DEBUG making gem world'

gii = RubyTextGame::IdGenerator.new

gid = gii.get
puts "gem id: #{gid}"

puts 'DEBUG puts start_game_repl called'

# ii = IdGenerator.new

# id = ii.get
# puts "id: #{id}"

# id = ii.get
# puts "id: #{id}"

puts 'DEBUG puts start_game_repl called'

def init_world
  world = RubyTextGame::World.new
  world.Start # TODO: add world.Stop? Where?
  ApplicationHelper.set_world(world)

  puts 'DEBUG init_world 0'

  roomA = RubyTextGame::Room.new(world.new_id, 'A small garden', "This garden isn't very large.",
                                 'The garden smells like wildflowers')
  roomB = RubyTextGame::Room.new(world.new_id, 'A large kitchen',
                                 'This kitchen is quite large. Pots hang on the walls, and something smells good.', 'The garden smells like wildflowers')

  world.link_rooms(roomA, RubyTextGame::Direction::EAST, roomB)

  player = world.make_player('rob', roomA) # TODO: make users createable

  sword = RubyTextGame::Sword.new(world.new_id, 'a short sword', 'This is a very shiny sword.', 42)
  cup = RubyTextGame::GameObject.new(world.new_id, 'cup', 'an ornate silver cup', 'This cup is very ornate and silver.')

  player.add_item(sword)
  player.add_item(cup)

  world_key = RubyTextGame.make_world_key(world)
  player.add_item(world_key)

  puts 'DEBUG init_world 98'

  goblin = RubyTextGame::NPC.new(world.new_id, 'goblin', 'a pungent goblin', 'This goblin is quite rank.', true)
  player.add_item(goblin)

  puts 'DEBUG init_world 99'
end

init_world
