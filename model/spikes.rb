#!/usr/bin/env ruby

require "rubygame"
require "global"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
 
# A class representing the player's ship moving in "space".
class Goon
	include Sprites::Sprite
  
  def initialize( px, py )
    @image = Surface.new(SHIP)
    @image.draw([],
    	[255,50,50])
    @rect = @image.make_rect
  end
  private
end
