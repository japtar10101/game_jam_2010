#!/usr/bin/env ruby

#add the import statements
require "rubygame"

RESOLUTION = [640,640]

#Simple basis
class View
	attr_accessor :models
	
	#constructor
	def initialize(screen)
		# retain a screen instance
		@screen = screen
		
		# retain a list of sprites to draw
		@models = Array.new
	end
	
	def draw
		for model in @models
			model.draw @screen
		end
	end
end

