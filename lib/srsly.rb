# -*- coding: utf-8 -*-

require 'pathname'
require 'yaml'
#require 'readline'
require 'forwardable'
require 'delegate'

require_relative 'srsly/rating'
require_relative 'srsly/strategies'
require_relative 'srsly/card_state'
require_relative 'srsly/card'
require_relative 'srsly/fixtures'
require_relative 'srsly/deck'
#require_relative 'srsly/cli'

module Srsly
end

#Srsly::CLI.new(Srsly::FIXTURES).readline_loop
