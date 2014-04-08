# -*- coding: utf-8 -*-

require 'pathname'
require 'yaml'
#require 'readline'
require 'forwardable'
require 'delegate'

require_relative 'xflash/rating'
require_relative 'xflash/strategies'
require_relative 'xflash/card_state'
require_relative 'xflash/card'
require_relative 'xflash/fixtures'
require_relative 'xflash/deck'
#require_relative 'xflash/cli'

module XFlash
end

#XFlash::CLI.new(XFlash::FIXTURES).readline_loop
