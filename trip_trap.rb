#!/usr/bin/env ruby
 
require "rubygame"
require "model/ship"
require "model/goon"
require "model/group"
require "model/spike"
require "model/wall"
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
  
# The Game class helps organize thing. It takes events
# from the queue and handles them, sometimes performing
# its own action (e.g. Escape key = quit), but also
# passing the events to the pandas to handle.
#
class Game
  include EventHandler::HasEventHandler
 
  def initialize()
    make_screen [FULLSCREEN, DOUBLEBUF]
    make_clock
    make_queue
    make_event_hooks
    @ship = Ship.new( @screen.w/2, @screen.h/2, RESOLUTION )
    make_magic_hooks_for( @ship, { YesTrigger.new() => :handle } )
    @goons = Group.new
    @spikes = Group.new
    @walls = Group.new
    @layout = LayoutGenerator.new
    load_file('levels/test.yaml')
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
 
  def load_file(string)
  	@layout.load_file(string)
  	@layout.generate_layout(@ship, @goons, @walls, @spikes)
    for goon in @goons 
  		make_magic_hooks_for( goon, { YesTrigger.new() => :handle } )
  	end
  	for spike in @spikes 
  		make_magic_hooks_for( spike, { YesTrigger.new() => :handle } )
  	end
  	for wall in @walls 
  		make_magic_hooks_for( wall, { YesTrigger.new() => :handle } )
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
    
    # Check if the ship died
    if @ship.is_dead?
    	puts "You've been gooned!"
    	quit
    end
    
    # check if any goons are alive
    win = true
    for goon in @goons
    	unless goon.dead
    		win = false
    		break 
    	end
    end
    if win
    	puts 'You won!'
    	quit
    end
 
    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events
 
    # Tick the clock and add the TickEvent to the queue.
    @queue << @clock.tick
 
    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end
 
    # have goons bounce off of each other
    @goons.collide_group(@walls) do |goon, check|
    	check_rect = check.rect
    	goon_rect = goon.rect
    	xdiff = (check_rect.centerx - goon_rect.centerx).abs
    	ydiff = (check_rect.centery - goon_rect.centery).abs
    	#reflect
			if xdiff > ydiff
				#goon.pushy = -1 * goon.ay
				goon.vy *= -1
			else
				#goon.pushx = -1 * goon.ax
				goon.vx *= -1
			end
    end
    @goons.collide_self do |goon, check|
    	check_rect = check.rect
    	goon_rect = goon.rect
    	xdiff = (check_rect.centerx - goon_rect.centerx).abs
    	ydiff = (check_rect.centery - goon_rect.centery).abs
    	#reflect
			if xdiff > ydiff
				#goon.pushy = -1 * goon.ay
				goon.vy *= -1
			else
				#goon.pushx = -1 * goon.ax
				goon.vx *= -1
			end
    end
    
    # have goons die on spikes
    @spikes.collide_group(@goons) do |spike, goon|
    	goon.dead = true
    end
    
    # Draw everything
    @spikes.draw @screen
    @walls.draw @screen
    @goons.draw @screen
    @ship.draw @screen
    
    # Refresh the screen.
    @screen.update()
  end
 
end
 
# Start the main game loop. It will repeat forever
# until the user quits the game!
Game.new.go
 
# Make sure everything is cleaned up properly.
Rubygame.quit()
