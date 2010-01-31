#!/usr/bin/env ruby
 
require "rubygame"
require "model/ship"
require "model/goon"
require "model/group"
require "model/spike"
require "model/wall"
require "model/status"
require "model/menu"
require "model/image"
require "global"
require "layout"

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
 
puts 'Warning, images disabled' unless 
  ($image_ok = (VERSIONS[:sdl_image] != nil))
puts 'Warning, font disabled' unless 
  ($font_ok = (VERSIONS[:sdl_ttf] != nil))
puts 'Warning, sound disabled' unless
  ($sound_ok = (VERSIONS[:sdl_mixer] != nil))

# main executable
class TripTrap
  include EventHandler::HasEventHandler
  def initialize()
    make_screen [DOUBLEBUF]
    make_clock
    make_queue
    make_event_hooks
    @state = STATE_TITLE
    @layout = LayoutGenerator.new
    #@layout.load_file()
    
    
    #@menu = Image.new
  end
  
  # The "main loop". Repeat the #step method
  # over and over and over until the user quits.
  def run
    catch(:quit) do
      loop do
        step
      end
    end
  end
  
  private
  # Create a new Clock to manage the game framerate
  # so it doesn't use 100% of the CPU
  def make_clock
    @clock = Clock.new()
    @clock.target_framerate = 50
    @clock.calibrate
    @clock.enable_tick_events
  end
 
  # Set up the event hooks to perform actions in
  # response to certain events.
  def make_event_hooks
    hooks = {
      :escape => :quit,
      QuitRequested => :quit
    }
 
    make_magic_hooks( hooks )
  end
  
  # Create an EventQueue to take events from the keyboard, etc.
  # The events are taken from the queue and passed to objects
  # as part of the main loop.
  def make_queue
    # Create EventQueue with new-style events (added in Rubygame 2.4)
    @queue = EventQueue.new()
    @queue.enable_new_style_events
 
    # Don't care about mouse movement, so let's ignore it.
    @queue.ignore = [MouseMoved]
  end
 
  # Create the Rubygame window.
  def make_screen flags
    @screen = Screen.open( RESOLUTION, 0, flags )
    @screen.title = "Trip Trap"
  end
  
  # Quit the game
  def quit
    puts "Quitting!"
    throw :quit
  end
  
  # Do everything needed for one frame.
  def step
    # Clear the screen.
    @screen.fill( :black )
    
    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events
 
    # Tick the clock and add the TickEvent to the queue.
    @queue << @clock.tick
 
    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end
    
    # TODO: Draw everything
    
    # Refresh the screen.
    @screen.update()
  end
end

# Start the main game loop. It will repeat forever
# until the user quits the game!
TripTrap.new.run
 
# Make sure everything is cleaned up properly.
Rubygame.quit()
