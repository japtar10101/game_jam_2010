#!/usr/bin/env ruby
 
require "rubygame"
require "model/ship"
require "model/goon"
require "model/goon_group"

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
 
# The Game class helps organize thing. It takes events
# from the queue and handles them, sometimes performing
# its own action (e.g. Escape key = quit), but also
# passing the events to the pandas to handle.
#
RESOLUTION = [800, 800]
class Game
  include EventHandler::HasEventHandler
 
  def initialize()
    make_screen
    make_clock
    make_queue
    make_event_hooks
    make_ship
    make_goons 8
  end
 
  # The "main loop". Repeat the #step method
  # over and over and over until the user quits.
  def go
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
      :q => :quit,
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
  def make_screen
    @screen = Screen.open( RESOLUTION )
    @screen.title = "Trip Trap"
  end
 
  # Create the player ship in the middle of the screen
  def make_ship
    @ship = Ship.new( @screen.w/2, @screen.h/2 )
 
    # Make event hook to pass all events to @ship#handle().
    make_magic_hooks_for( @ship, { YesTrigger.new() => :handle } )
  end
  
  # Create the goons someplace in the screen
  def make_goons num
  	@goons = GoonGroup.new @ship
  	num.times do |i|
  		goon = Goon.new( rand(RESOLUTION[0]), rand(RESOLUTION[1]) )
  		@goons << goon
		end
		make_magic_hooks_for( @goons, { YesTrigger.new() => :handle } )
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
 
    # Draw the ship in its new position.
    @ship.draw( @screen )
 
    @goons.draw(@screen)
    #for goon in @goons
    #	goon.draw( @screen )
    #end

    # Refresh the screen.
    @screen.update()
  end
 
end
 
# Start the main game loop. It will repeat forever
# until the user quits the game!
Game.new.go
 
# Make sure everything is cleaned up properly.
Rubygame.quit()
