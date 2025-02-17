module ApplicationHelper
  @@world = nil

  @@global_str = "foo"

  def self.get_world
    @@world
  end

  def self.set_world(world)
    @@world = world
  end

  def self.get_global_str
    @@global_str
  end

  def self.set_global_str(st)
    @@global_str = st
  end
end
