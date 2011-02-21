#!/usr/bin/env ruby

require "rubygame"

# load the rest of the files
@root = File.dirname(__FILE__)
puts @root
Dir[@root + '/../model/*.rb'].each do |file|
  puts file
  load file
end
load (@root + '/../global.rb')
load (@root + '/../layout.rb')

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

# The Game class helps organize thing. It takes events
# from the queue and handles them, sometimes performing
# its own action (e.g. Escape key = quit), but also
# passing the events to the pandas to handle.
#
class GameController
  include EventHandler::HasEventHandler

  attr_reader :state
  def initialize(layout, screen)
  	# retain the layout (shared pointer)
  	@layout = layout

  	# make status for game
  	@screen = screen
  	@status = Status.new(screen)

  	# making ship (which will always have controls)
    @ship = Ship.new( @screen.w/2, @screen.h/2, RESOLUTION )

    # make collision groups
    @goons = Group.new
    @spikes = Group.new
    @walls = Group.new

    # retain state
    @state = GAME_RUNNING
  end

  def load_layout()
  	@ship.remove_hook MAGIC_HOOKS
  	for goon in @goons
  		goon.remove_hook MAGIC_HOOKS
  	end
  	for spike in @spikes
  		spike.remove_hook MAGIC_HOOKS
  	end
  	for wall in @walls
  		wall.remove_hook MAGIC_HOOKS
  	end
  	@layout.generate_layout(@ship, @goons, @walls, @spikes)
  	@state = GAME_RUNNING
    for goon in @goons
  		make_magic_hooks_for( goon, MAGIC_HOOKS )
  	end
  	for spike in @spikes
  		make_magic_hooks_for( spike, MAGIC_HOOKS )
  	end
  	for wall in @walls
  		make_magic_hooks_for( wall, MAGIC_HOOKS )
  	end
  	make_magic_hooks_for( @ship, MAGIC_HOOKS )
  end

  # Do everything needed for one frame.
  def step
    # Check if the ship died
    if @ship.is_dead?
    	@state = GAME_LOST
    	return @state
    end

    # check if any goons are alive
    num_goons = 0
    for goon in @goons
    	num_goons += 1 unless goon.dead
    end
    if num_goons == 0
    	@state = GAME_WON
    	return @state
    end

    # have goons bounce off of each other
    draw(num_goons)
    return @state
  end

  private

  def draw num_goons
  	# have goons bounce off of each other
    @goons.collide_self do |goon, check|
    	check_rect = check.rect
    	goon_rect = goon.rect
    	xdiff = (check_rect.centerx - goon_rect.centerx).abs
    	ydiff = (check_rect.centery - goon_rect.centery).abs
    	#reflect
			if xdiff > ydiff
				goon.vy *= -1
			else
				goon.vx *= -1
			end
    end

    # have goons die on spikes
    @spikes.collide_group(@goons) do |spike, goon|
    	goon.dead = true
    end

    # Draw everything
    @status.render_text @ship.health.to_s, num_goons.to_s
    @spikes.draw @screen
    @walls.draw @screen
    @goons.draw @screen
    @ship.draw @screen
  end
end

