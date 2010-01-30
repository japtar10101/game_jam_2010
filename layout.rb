#!/usr/bin/env ruby

require "yaml"
require "global"

class LayoutGenerator
	yaml = YAML.load_file 'test.yaml'
	puts yaml
end

