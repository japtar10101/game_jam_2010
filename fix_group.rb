#!/usr/bin/env ruby

require "rubygame"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
 
# A class representing the player's ship moving in "space".
class FixGroup < Sprites::Group
	include Sprites::UpdateGroup
	def initialize()
		super()
		@sprites = []
	end
	def <<(sprite)
		unless( @sprites.include?(sprite) )
			@sprites << sprite
			sprite.add(self)
		end
		self
	end
end

