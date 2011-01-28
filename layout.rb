#!/usr/bin/env ruby

require "yaml"
require "global"

class LayoutGenerator
	
	attr_reader :title, :goons, :comment, :layout
	def initialize()
		@title
		@goons
		@comment
		@layout
	end
	
	def load_file( filename )
		yaml = YAML.load_file filename
		@title = yaml["title"]
		@goons = yaml["goons"]
		@comment = yaml["comment"]
		@layout = yaml["layout"]
	end
	
	def generate_layout(ship, goons, walls, spikes)
		goons.clear
		walls.clear
		spikes.clear
		
		y = SHIP[1]
		@layout.each do |string|
			x = 0
			string.chars do |char|
				case char
				when "h"
					place_ship ship, x, y
				when "w"
					place_wall walls, x, y, ship
				when "s"
					place_spike spikes, x, y, ship
				when "g"
					place_goons goons, x, y, ship
				end
				x += SHIP[0]
			end
			y += SHIP[1]
		end
		
	end
	
	private
	
	def place_ship(ship, x, y)
		ship.placement x, y
	end
	
	def place_wall(wall, x, y, ship)
		wall << Wall.new( x, y, ship )
	end
	
	def place_spike(spikes, x, y, ship)
		spikes << Spike.new( x, y, ship )
	end
	
	def place_goons(goons, x, y, ship)
		xtemp = 0
		@goons.times do |i|
			goons << Goon.new( x + xtemp, y, ship, RESOLUTION )
  		xtemp += GOON[0] * 2
  		if xtemp > SHIP[0]
  			xtemp = 0
  			y += GOON[1] * 2
  		end
  	end
	end
end

