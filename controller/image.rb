#!/usr/bin/env ruby
 
require "rubygame"
require "model/image"
require "global"
require "layout"

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
 
# The Game class helps organize thing. It takes events
# from the queue and handles them, sometimes performing
# its own action (e.g. Escape key = quit), but also
# passing the events to the pandas to handle.
#
class ImageController
  attr_reader :menu
  def initialize(layout, screen)
  	# retain the layout (shared pointer)
  	@layout = layout
  	
  	# make status for game
  	@screen = screen
  	
  	# making menu
    @image = Image.new @layout
  end
 
  def set_image(filename)
  	@image.set_file(filename)
  end
  
  # Do everything needed for one frame.
  def step
    # Draw everything
    @image.draw @screen
  end
end
 
