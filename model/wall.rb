#!/usr/bin/env ruby

require "rubygame"
require "global"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
 
# A class representing the player's ship moving in "space".
class Wall
	include Sprites::Sprite
	include EventHandler::HasEventHandler
  
  def initialize( px, py, ship )
    @image = Surface.load('sprites/walls.png')
    @rect = @image.make_rect
    @rect.topleft = [px, py]
    @ship = ship
    
    # Create event hooks in the easiest way.
    make_magic_hooks(
      ClockTicked => :update
    )
  end
  
  private
  # Update the ship state. Called once per frame.
  def update( event )
  	ship_rect = @ship.rect
    spikex = @rect.centerx
    spikey = @rect.centery
    vy = @ship.vy
    vx = @ship.vx
    
  	#implement repulsion
    if(@ship.collide_sprite?(self))
    	if (@rect.bottom > ship_rect.top and vy < 0)
				@ship.pushy *= -1
			elsif (@rect.top < ship_rect.bottom and vy > 0)
				@ship.pushy *= -1
			end
			if (@rect.left < ship_rect.right and vx < 0)
				@ship.pushx *= -1
			elsif (@rect.right > ship_rect.left and vx > 0)
				@ship.pushx *= -1
			end
		end
  end
end
