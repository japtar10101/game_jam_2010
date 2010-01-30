#!/usr/bin/env ruby

require "rubygame"

# Include these modules so we can type "Surface" instead of
# "Rubygame::Surface", etc. Purely for convenience/readability.
 
include Rubygame
include Rubygame::EventTriggers

# collision detection for goons
class GoonGroup < Sprites::Group
  include Sprites::UpdateGroup
  include EventHandler::HasEventHandler
  
  def initialize( ship )
  	super()
  	@ship = ship
  	  
  	# Create event hooks in the easiest way.
    make_magic_hooks(
      ClockTicked => :update
    )
  end
  
  def <<(goon)
  	goon.ship = @ship
  	make_magic_hooks_for( goon, { YesTrigger.new() => :handle } )
  	#super << goon
  end
  
  private
  # Update the ship state. Called once per frame.
  def update( event )
  	self.collide_group(self) do |a, b|
  		a_rect = a.rect
  		b_rect = b.rect
  		#left
			if a_rect.centerx < b_rect.centerx
				a.pushx -= 1
			#right
			elsif a_rect.centerx > b_rect.centerx
				a.pushx += 1
			end
			#up
			if a_rect.centery < b_rect.centery
				a.pushy -= 1
			#down
			elsif a_rect.centery > b_rect.centery
				a.pushy += 1
			end
  	end
  end
end
