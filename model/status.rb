#!/usr/bin/env ruby

require "rubygame"

include Rubygame

class Status
	def initialize(screen)
		@screen = screen
	end
	
	# Render some text with TTF (vector-based font)
	def render_text( health, goons )
		result = FONT.render( "HEALTH: #{health}", true, STATUS_COLOR )
		result.blit( @screen, [STATUS_HEALTH_X,STATUS_Y] )
		
		result = FONT.render( "BEES: #{goons}", true, STATUS_COLOR )
		result.blit( @screen, [STATUS_GOONS_X,STATUS_Y] )
	end
end
