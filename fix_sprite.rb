#!/usr/bin/env ruby

require "rubygame"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
 
# A class representing the player's ship moving in "space".
class MySprite
  include Sprites::Sprite
 
  def include? group
  	return @groups.include? group
  end
end

