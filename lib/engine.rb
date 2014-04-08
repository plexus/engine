# -*- coding: utf-8 -*-

require 'pathname'
require 'yaml'
#require 'readline'
require 'forwardable'
require 'delegate'

require_relative 'engine/rating'
require_relative 'engine/strategies'
require_relative 'engine/card_state'
require_relative 'engine/card'
require_relative 'engine/fixtures'
require_relative 'engine/deck'
#require_relative 'engine/cli'

module Engine
end

#Engine::CLI.new(Engine::FIXTURES).readline_loop
