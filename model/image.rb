#!/usr/bin/env ruby

require "rubygame"
load (File.dirname(__FILE__) + '/../global.rb')

include Rubygame

class Image
	include Sprites::Sprite

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
