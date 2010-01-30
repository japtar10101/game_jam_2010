#!/usr/bin/env ruby

require 'rubygame'
require 'model/hero'
require 'view/view'

include Rubygame

class Game
	def initialize
		@screen = Screen.new(RESOLUTION, 0, [HWSURFACE, DOUBLEBUF])
		@screen.title = "This is not a game"
		@screen.fill( :white )

		@queue = EventQueue.new
		@clock = Clock.new
		@clock.target_framerate = 30
		
		if(defined?(Surface.load) == nil)
			raise "Cannot upload images!"
		end
		@hero = Hero.new
	end

	def run
		#keep looping until done!
		loop do
			update
			draw
			@clock.tick
		end
	end

	private
	def update
		@queue.each do |ev|
			case ev
			#TODO: add other mouse events
			when QuitEvent
				end_game
			end
		end
	end

	def end_game
		Rubygame.quit
		exit
	end
	
	def draw
		#TODO: do something!
	end
end
 
game = Game.new
game.run

