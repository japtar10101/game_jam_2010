#!/usr/bin/env ruby

require "rubygame"
require "yaml"
require "global"

include Rubygame

class Menu
	include Sprites::Sprite
  include EventHandler::HasEventHandler
  
  attr_reader :layout
	def initialize layout = nil
		if layout
    	@layout = layout
    else
    	@layout = LayoutGenerator.new
    end
    @intro = true
    @levels = YAML.load_file filename
	end
	
	
end
