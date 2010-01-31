#!/usr/bin/env ruby
 
require "rubygame"
require "controller/menu"
require "controller/game"
require "controller/image"
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
    make_controller
    @state = STATE_TITLE
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
      QuitRequested => :quit,
      :return => :change_state
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
    
    # Draw everything
    step_state
    
    # Refresh the screen.
    @screen.update()
  end
  
  def change_state
  	#TODO: remove the quit statements after figuring out the odd collisions
  	case @state
		when STATE_TITLE
  		@state = STATE_MENU
  		@menu.activate true
  	when STATE_WIN
  		quit
  		@state = STATE_MENU
  		@menu.activate true
  	when STATE_LOSE
  		quit
  		@state = STATE_MENU
  		@menu.activate true
		when STATE_DIRECTIONS
  		@state = STATE_MENU
  		@menu.activate true
  	when STATE_MENU
  		# load the layout
  		if @menu.get_filename()
  			@state = STATE_GAME
  			@game.load_layout()
  		else
  			@image.set_image 'sprites/directions.png'
  			@state = STATE_DIRECTIONS
  		end
  		@menu.activate false
  	end
  end
  
  def step_state
  	# add image
  	case @state
		when STATE_MENU
  		@menu.step
  	when STATE_GAME
  		# check the game state
  		state = @game.step
  		if state == GAME_WON
  			@state = STATE_WIN
  			@image.set_image 'sprites/win.png'
  		elsif state == GAME_LOST
  			@state = STATE_LOSE
  			@image.set_image 'sprites/lose.png'
  		end
  	when STATE_TITLE
  		@image.step
  	when STATE_DIRECTIONS
  		@image.step
  	when STATE_WIN
  		@image.step
		when STATE_LOSE
  		@image.step
  	end
  end
  
  def make_controller
  	@layout = LayoutGenerator.new
  	@menu = MenuController.new(@layout, @screen)
  	make_magic_hooks_for( @menu, MAGIC_HOOKS )
  	@game = GameController.new(@layout, @screen)
  	make_magic_hooks_for( @game, MAGIC_HOOKS )
  	@image = ImageController.new(@layout, @screen)
  end
end

# Start the main game loop. It will repeat forever
# until the user quits the game!
TripTrap.new.run
 
# Make sure everything is cleaned up properly.
Rubygame.quit()
