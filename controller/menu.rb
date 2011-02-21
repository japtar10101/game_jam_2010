#!/usr/bin/env ruby

require "rubygame"

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

# load the rest of the files
@root = File.dirname(__FILE__)
load @root + '/../model/menu.rb'
load @root + '/../global.rb'
load @root + '/../layout.rb'

# The Game class helps organize thing. It takes events
# from the queue and handles them, sometimes performing
# its own action (e.g. Escape key = quit), but also
# passing the events to the pandas to handle.
#
class MenuController
  include EventHandler::HasEventHandler

  attr_reader :menu
  def initialize(layout, screen)
  	# retain the layout (shared pointer)
  	@layout = layout

  	# make status for game
  	@screen = screen

  	# making menu
    @menu = Menu.new
    make_magic_hooks_for( @menu, MAGIC_HOOKS )
  end

  def get_filename()
  	filename = @menu.get_filename()
  	@layout.load_file(filename) if filename
  	return filename
  end

  def activate bool
  	@menu.control = bool
  end

  # Do everything needed for one frame.
  def step
    # Draw everything
    @menu.draw @screen
  end
end

