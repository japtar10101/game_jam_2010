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
    
    #store level data
    @levels = YAML.load_file filename
    
    #setup items and index to display
    @items = Array.new(2)
    set_items_to_intro
    @index = 0
    
    #load an image
    @image = Surface.load('sprites/spikes.png')
    @image.fill(:white)
    @rect = @image.make_rect
    
    # Create event hooks in the easiest way.
    make_magic_hooks(
 
      # Send keyboard events to #key_pressed() or #key_released().
      KeyPressed => :key_pressed,
      KeyReleased => :key_released,
 
      # Send ClockTicked events to #update()
      ClockTicked => :update
    )
	end
	
	private
	def set_items_to_intro
		@index = 0
		@items.clear
		@items << "Start"
		@items << "How to Play"
	end
	
	# Add it to the list of keys being pressed.
  def key_pressed( event )
    @keys += [event.key]
  end
 
 
  # Remove it from the list of keys being pressed.
  def key_released( event )
    @keys -= [event.key]
  end
	
  # Update the ship state. Called once per frame.
  def update( event )
    dt = event.seconds # Time since last update
 
		update_accel
		update_vel dt 
		update_pos dt
		
		@invulnerable -= 1 if @invulnerable > 0
  end
end
