#!/usr/bin/env ruby

require "rubygame"
require "global"

include Rubygame

class Image
	include Sprites::Sprite
  include EventHandler::HasEventHandler
  
  attr_reader :layout
	def initialize layout = nil
		if layout
    	@layout = layout
    else
    	@layout = LayoutGenerator.new
    end
    
    #load an image
    set_file('sprites/logo.png')
	end
	
	def set_file(filename)
    @image = Surface.load(filename)
    @rect = @image.make_rect
    @rect.topleft = [0,0]
	end
end
