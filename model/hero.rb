#!/usr/bin/env ruby

#add the import statements
require "rubygame"
require "model/model"
include Rubygame

#Start with making a character
class Hero < Model
	#constructor
	def initialize()
		super(0,0,'sprites/hero.png')
	end
end

