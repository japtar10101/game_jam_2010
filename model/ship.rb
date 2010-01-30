#!/usr/bin/env ruby
 
require "rubygame"

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
 
  attr_accessor :pushx, :pushy
  attr_reader :ax, :ay, :vx, :vy
  def initialize( px, py, screen_rect )
    @px, @py = px, py # Current Position
    @vx, @vy = 0, 0 # Current Velocity
    @ax, @ay = 0, 0 # Current Acceleration
    @pushx, @pushy = 0, 0 # Controlled Acceleration
    
    @max_speed = 400.0 # Max speed on an axis
    @accel = 1200.0 # Max Acceleration on an axis
    @slowdown = 800.0 # Deceleration when not accelerating
 
    @keys = [] # Keys being pressed
 
 
    # The ship's appearance. A white square for demonstration.
    @image = Surface.new([20,20])
    @image.fill(:white)
    @rect = @image.make_rect
    @screenx = screen_rect.right
    @screeny = screen_rect.bottom
 
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
    update_vel( dt )
    update_pos( dt )
  end
 
 
  # Update the acceleration based on what keys are pressed.
  def update_accel
    @pushx -= 1 if @keys.include?( :left )
    @pushx += 1 if @keys.include?( :right )
    @pushy -= 1 if @keys.include?( :up ) # up is down in screen coordinates
    @pushy += 1 if @keys.include?( :down )
 
    # Scale to the acceleration rate. This is a bit unrealistic, since
    # it doesn't consider magnitude of x and y combined (diagonal).
    @pushx *= @accel
    @pushy *= @accel
 
    @ax, @ay = @pushx, @pushy
    @pushx, @pushy = 0, 0
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
 
    # Apply slowdown if not accelerating.
    if a == 0
      if v > 0
        v -= @slowdown * dt
        v = 0 if v < 0
      elsif v < 0
        v += @slowdown * dt
        v = 0 if v > 0
      end
    end
 
    # Apply acceleration
    v += a * dt
 
    # Clamp speed so it doesn't go too fast.
    v = @max_speed if v > @max_speed
    v = -@max_speed if v < -@max_speed
 
    return v
  end
 
 
  # Update the position based on the velocity and the time since last
  # update.
  def update_pos( dt )
    @px += @vx * dt
    @py += @vy * dt
 
    if @px < 0
    	@px = @screenx
    elsif @px > @screenx
    	@px = 0
    end
    if @py < 0
    	@py = @screeny
    elsif @py > @screeny
    	@py = 0
    end
    @rect.center = [@px, @py]
  end
 
end
