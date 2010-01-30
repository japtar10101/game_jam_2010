#!/usr/bin/env ruby

#add the import statements
require "rubygame"

#Simple basis
class Model
	Rubygame::Sprites::Sprite
	#constructor
	def initialize( x, y, file )
		#position
		@position = [x, y]
		
		#upload an image
		@image = Surface.load(file)
		@rect = @image.make_rect
		@rect.center = @position
	end
	
	#positions the sprite
	def position(x,y)
		@position[0] = x
		@position[1] = y
		
		#do I need this line?
		@rect.center = @position
	end
end

