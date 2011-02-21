#!/usr/bin/env ruby

require "rubygame"
require "yaml"
load (File.dirname(__FILE__) + '/../global.rb')

include Rubygame

class Menu
	include Sprites::Sprite
  include EventHandler::HasEventHandler

  attr_reader :layout
  attr_accessor :control
	def initialize layout = nil
		if layout
    	@layout = layout
    else
    	@layout = LayoutGenerator.new
    end

    #store level data
    @levels = YAML.load_file LEVEL_FILE

    #setup items and index to display
    @items = Array.new()
    set_items_to_intro
    @index = 0

    #load an image
    #@image = Surface.load('sprites/logo.png')
    @rect = Rect.new
    @rect.topleft = [0,0]

    # Create event hooks in the easiest way.
    make_magic_hooks(
    	#go through menu items
      :up => :up_item,
      :down => :down_item
    )
    @control = false
	end

	def draw(screen)
		y = MENU_Y
		@items.each_index do |i|
			string = @items[i]
			result = nil
			if i == @index
				result = FONT.render( string, true, SELECT_COLOR )
			else
				result = FONT.render( string, true, STATUS_COLOR )
			end
			x = RESOLUTION[0] / 2 - result.width / 2
			result.blit( screen, [x , y] )
			y += result.height
		end
	end

	def get_filename
		return nil if @index == 0
		index = @index - 1
		hash = @levels[index]
		return hash["file"]
	end

	private
	def set_items_to_intro
		@index = 0
		@items.clear
		@items << "How to Play"
		for hash in @levels
			filename = hash["file"]
			@layout.load_file(filename)
			@items << @layout.title
		end
	end

	# go up list.
  def up_item
  	if(@control)
			@index -= 1
			@index = @items.length - 1 if @index < 0
		end
  end


  # go down list.
  def down_item
  	if(@control)
			@index += 1
			@index = 0 if @index >= @items.length
		end
  end
end
