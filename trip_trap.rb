#!/usr/bin/env ruby
 
require "rubygame"
require "model/ship"
require "model/goon"
require "model/group"

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
    make_goons 16
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
    @ship = Ship.new( @screen.w/2, @screen.h/2, @screen.make_rect )
 
    # Make event hook to pass all events to @ship#handle().
    make_magic_hooks_for( @ship, { YesTrigger.new() => :handle } )
  end
  
  # Create the goons someplace in the screen
  def make_goons num
  	@goons = Group.new
  	num.times do |i|
  		@goons << Goon.new( rand(RESOLUTION[0]), rand(RESOLUTION[1]),
  			@ship, @screen.make_rect )
  	end
  	for goon in @goons 
  		make_magic_hooks_for( goon, { YesTrigger.new() => :handle } )
  	end
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
 
    #HACK: have goons detect each other
    @goons.collide_self do |goon, check|
    	check_rect = check.rect
    	goon_rect = goon.rect
    	xdiff = (check_rect.centerx - goon_rect.centerx).abs
    	ydiff = (check_rect.centery - goon_rect.centery).abs
    	#reflect
			if xdiff > ydiff
				#goon.pushy = -0.3 * goon.ay
				goon.vy *= -0.3
			else
				#goon.pushx = -0.3 * goon.ax
				goon.vx *= -0.3
			end
    end
    
    @goons.draw @screen

    # Refresh the screen.
    @screen.update()
  end
 
end
 
# Start the main game loop. It will repeat forever
# until the user quits the game!
Game.new.go
 
# Make sure everything is cleaned up properly.
Rubygame.quit()
