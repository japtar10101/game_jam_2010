#!/usr/bin/env ruby

require "rubygame"

include Rubygame

class Status
	def initialize(screen)
		@screen = screen
		
		#setup font
		TTF.setup()
		ttfont_path = File.join(File.dirname(__FILE__), STATUS_FONT)
		@ttfont = TTF.new( ttfont_path, STATUS_SIZE )
	end
	
	# Render some text with TTF (vector-based font)
	def render_text( health, goons )
		result = @ttfont.render( "HEALTH: #{health}", true, STATUS_COLOR )
		result.blit( @screen, [STATUS_HEALTH_X,STATUS_Y] )
		
		result = @ttfont.render( "GOONS: #{goons}", true, STATUS_COLOR )
		result.blit( @screen, [STATUS_GOONS_X,STATUS_Y] )
	end
end
