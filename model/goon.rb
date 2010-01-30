#!/usr/bin/env ruby

require "rubygame"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers
 
# A class representing the player's ship moving in "space".
class Goon
	include Sprites::Sprite
  include EventHandler::HasEventHandler
  PUSH = 5
  
  attr_accessor :ship, :pushx, :pushy, :vx, :vy
  attr_reader :ax, :ay
  def initialize( px, py, ship, screen_rect )
    @px, @py = px, py # Current Position
    @vx, @vy = 0, 0 # Current Velocity
    @ax, @ay = 0, 0 # Current Acceleration
    @pushx, @pushy = 0, 0 # Controlled Acceleration
 
    @max_speed = 400.0 # Max speed on an axis
    @accel = 1200.0 # Max Acceleration on an axis
    @slowdown = 800.0 # Deceleration when not accelerating
 
    @image = Surface.new([5,5])
    @image.fill(:white)
    @rect = @image.make_rect
    @ship = ship
    @screenx = screen_rect.right
    @screeny = screen_rect.bottom
    
    # Create event hooks in the easiest way.
    make_magic_hooks(
      ClockTicked => :update
    )
  end
 
 
  private
  # Update the ship state. Called once per frame.
  def update( event )
    dt = event.seconds # Time since last update
 
    update_accel
    update_vel( dt )
    update_pos( dt )
  end
 
 
  # Update the acceleration based on what keys are pressed.
  def update_accel
    ship_rect = @ship.rect
    goonx = @rect.centerx
    goony = @rect.centery
    #left
    if ship_rect.centerx < goonx
    	@pushx -= 1
    #right
    elsif ship_rect.centerx > goonx
    	@pushx += 1
    end
    #up
    if ship_rect.centery < goony
    	@pushy -= 1
    #down
    elsif ship_rect.centery > goony
    	@pushy += 1
    end
 
    # Scale to the acceleration rate. This is a bit unrealistic, since
    # it doesn't consider magnitude of x and y combined (diagonal).
    @pushx *= @accel
    @pushy *= @accel
 
    #implement reflection
    if(@ship.collide_sprite?(self))
			if (goony > ship_rect.top and @vy < 0)
				@pushy *= -1
				@ship.pushy -= PUSH
			elsif (goony < ship_rect.bottom and @vy >= 0)
				@pushy *= -1
				@ship.pushy += PUSH
			end
			if (goonx > ship_rect.right and @vx < 0)
				@pushx *= -1
				@ship.pushx -= PUSH
			elsif (goonx < ship_rect.left and @vx >= 0)
				@pushx *= -1
				@ship.pushx += PUSH
			end
		end
			
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
