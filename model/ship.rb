#!/usr/bin/env ruby
 
require "rubygame"
require "global"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
 
# A class representing the player's ship moving in "space".
class Ship
  include Sprites::Sprite
  include EventHandler::HasEventHandler
 
  attr_accessor :pushx, :pushy, :accel
  attr_reader :ax, :ay, :vx, :vy, :health
  def initialize( px, py, screen_rect )
    @px, @py = px, py # Current Position
    @vx, @vy = 0, 0 # Current Velocity
    @ax, @ay = 0, 0 # Current Acceleration
    @pushx, @pushy = 0, 0 # Controlled Acceleration
    @keys = [] # Keys being pressed
 
    # The ship's appearance. A white square for demonstration.
    @image = Surface.new(SHIP)
    @image.fill(:white)
    @rect = @image.make_rect
    @health = SHIP_HEALTH
    @invulnerable = 0
    
    # Create event hooks in the easiest way.
    make_magic_hooks(
 
      # Send keyboard events to #key_pressed() or #key_released().
      KeyPressed => :key_pressed,
      KeyReleased => :key_released,
 
      # Send ClockTicked events to #update()
      ClockTicked => :update
    )
  end
  
  def placement(x, y)
  	@px, @py = x, y # Current Position
    @vx, @vy = 0, 0 # Current Velocity
    @ax, @ay = 0, 0 # Current Acceleration
    @health = SHIP_HEALTH
  	@rect.topleft = [@px, @py]
  end
  
  def hit
  	if @invulnerable <= 0
  		@health -= 1
  		@invulnerable = SHIP_INVULNERABLE
  	end
  end

  def is_dead?
  	@health <= 0
  end
  
  private
 
 
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
 
 
  # Update the acceleration based on what keys are pressed.
  def update_accel
  	if(@pushx)
			@pushy = 0 unless(@pushy)
			@pushx -= 1 if @keys.include?( :left )
			@pushx += 1 if @keys.include?( :right )
			@pushx *= SHIP_ACCEL
			@ax = @pushx
			@pushx = 0
		else
			@ax = @pushx
		end
		if(pushy)
			@pushy -= 1 if @keys.include?( :up ) # up is down in screen coordinates
			@pushy += 1 if @keys.include?( :down )
			@pushy *= SHIP_ACCEL
			@ay = @pushy
			@pushy = 0
		else
			@ax = @pushy
		end
  end
 
 
  # Update the velocity based on the acceleration and the time since
  # last update.
  def update_vel( dt )
    @vx = update_vel_axis( @vx, @ax, dt )
    @vy = update_vel_axis( @vy, @ay, dt )
  end
 
 
  # Calculate the velocity for one axis.
  # v = current velocity on that axis (e.g. @vx)
  # a = current acceleration on that axis (e.g. @ax)
  #
  # Returns what the new velocity (@vx) should be.
  #
  def update_vel_axis( v, a, dt )
  	return 0 unless a
 
    # Apply slowdown if not accelerating.
    if a == 0
      if v > 0
        v -= SLOWDOWN * dt
        v = 0 if v < 0
      elsif v < 0
        v += SLOWDOWN * dt
        v = 0 if v > 0
      end
    end
 
    # Apply acceleration
    v += a * dt
 
    # Clamp speed so it doesn't go too fast.
    v = SHIP_MAX_SPEED if v > SHIP_MAX_SPEED
    v = -SHIP_MAX_SPEED if v < -SHIP_MAX_SPEED
 
    return v
  end
 
 
  # Update the position based on the velocity and the time since last
  # update.
  def update_pos( dt )
    @px += @vx * dt
    @py += @vy * dt
 
    if @px < 0
    	@px = RESOLUTION[0]
    elsif @px > RESOLUTION[0]
    	@px = 0
    end
    if @py < SHIP[1]
    	@py = RESOLUTION[1]
    elsif @py > RESOLUTION[1]
    	@py = SHIP[1]
    end
    @rect.center = [@px, @py]
  end
 
end
