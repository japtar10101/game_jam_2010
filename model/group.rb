#!/usr/bin/env ruby
 
require "rubygame"

class Group < Array
	def initialize()
		super()
	end
	
	def collide_sprite(sprite, &block)
		to_return = Array.new
		self.each do |check|
			to_return << check if sprite.collide_sprite?(check)
		end
		if block_given?
			to_return.each do |a|
				yield a
			end
		end
		return to_return
	end
	
	def collide_group(group, &block)
		sprites = {}
		self.each do |sprite|
			col = group.collide_sprite(sprite)
			sprites[sprite] = col if col.length > 0
		end
		if block_given?
			sprites.each_pair do |a, bs|
				bs.each { |b| yield(a, b) }
			end
		end
		return sprites
	end
	
	def collide_self(&block)
		sprites = {}
		col = Array.new
		for sprite in self
			col.clear
			for check in self
				#skip checking oneself
				next if check == sprite
				col << check if sprite.collide_sprite?(check)
			end
			sprites[sprite] = col if col.length > 0
		end
		if block_given?
			sprites.each_pair do |a, bs|
				bs.each { |b| yield(a, b) }
			end
		end
		return sprites
	end
	
	def draw(screen)
		self.each do |sprite|
			sprite.draw screen
		end
	end
end
