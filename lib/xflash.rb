# -*- coding: utf-8 -*-
require 'pathname'
require 'yaml'
require 'readline'
require 'forwardable'
require 'delegate'

require_relative 'xflash/rating'
require_relative 'xflash/strategies'
require_relative 'xflash/card_state'
require_relative 'xflash/card'
require_relative 'xflash/fixtures'
require_relative 'xflash/deck'

module XFlash
  class App
    attr_reader :card, :cards
    def initialize(cards)
      @cards = Deck.new(cards)
    end

    def next_card
      @card = cards.sample
    end

    def rate_card(score)
      puts "Before : " + card.inspect
      card.rate(score).tap do |new_card|
        @cards = @cards.update_card(card, new_card)
        @card  = new_card
      end
      puts "After  : " + card.inspect
    end

    def readline_loop
      next_card
      loop do
        input = Readline.readline("#{card.front} > ", true)
        exit unless input
        case input
        when /s/, ""
          puts card.back
        when /[0-5]/
          rate_card(input.to_i)
          next_card
        end
      end
    end
  end
end

XFlash::App.new(XFlash::FIXTURES.take(1)).readline_loop
