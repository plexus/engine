# -*- coding: utf-8 -*-
require 'pathname'
require 'yaml'
require 'readline'
require 'forwardable'
require 'delegate'

require_relative 'xflash/strategies'

module XFlash
  class Rating < Struct.new(:timestamp, :rating)
    MAX_RATING = 3
    FAIL = 0
    HARD = 1
    GOOD = 2
    EASY = 3

    def neg_rating
      MAX_RATING - rating
    end

    def fail? ; rating == FAIL end
    def hard? ; rating == HARD end
    def good? ; rating == GOOD end
    def easy? ; rating == EASY end
  end

  # CardStates form a linked list, each pointing to the previous state plus
  # the new data point. The actual factor/interval, streak are calculated
  # recursively based on the previous value, and the new data point.
  class CardState < Struct.new(:parent, :data_point)
    STRATEGY = AnkiStrategy
    EMPTY = CardState.new

    START = {
      iteration: 0,
      streak: 0,
      factor: 2.5,
      interval: 1
    }

    def << data_point
      self.class.new(self, data_point)
    end

    def strategy
      STRATEGY.new(parent, data_point)
    end

    def empty?
      parent.nil?
    end

    def data_points(&blk)
      return to_enum(__method__) unless block_given?
      unless empty?
        parent.data_points(&blk)
        yield data_point
      end
    end

    def iteration ; empty? ? START[:iteration] : parent.iteration + 1   end
    def streak    ; empty? ? START[:streak]    : strategy.next_streak   end
    def factor    ; empty? ? START[:factor]    : strategy.next_factor   end
    def interval  ; empty? ? START[:interval]  : strategy.next_interval end

    def inspect
      "<#{self.class} iteration: %d, streak: %d, factor: %.2f, interval: %.2f>" % [iteration, streak, factor, interval]
    end
  end

  class Card < Struct.new(:id, :front, :back, :card_state)
    extend Forwardable
    def_delegators :card_state, :factor, :interval

    def rate(rating)
      self.card_state <<= Rating.new(Time.now, rating)
      self
    end

    def inspect
      "<Card #{front} #{card_state.inspect}>"
    end
  end

  class App
    attr_reader :card, :cards
    def initialize(cards)
      @cards = cards
    end

    def next_card
      @card = cards.sample
    end

    def rate_card(score)
      puts "Before : " + card.inspect
      card.rate(score)
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

require_relative 'xflash/fixtures'

XFlash::App.new(XFlash::FIXTURES.take(1)).readline_loop
