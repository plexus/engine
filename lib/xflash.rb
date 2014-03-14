# -*- coding: utf-8 -*-
require 'pathname'
require 'yaml'
require 'readline'
require 'forwardable'
require 'delegate'

# DataPoint
# CardHistory
# CardState
# Card

module XFlash
  class DataPoint < Struct.new(:timestamp, :rating)
    MAX_RATING=3

    def neg_rating
      MAX_RATING - rating
    end

    def fail?
      rating == 0
    end
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
      self.history <<= DataPoint.new(Time.now, rating)
      self
    end

    def inspect
      "<Card #{front} #{card_state.inspect}>"
    end
  end

  FIXTURES = [
    [0, '入選', "(入选) [ru4 xuan3] /to be chosen/to be elected as/"],
    [1, '報名', "(报名) [bao4 ming2] /to sign up/to enter one's name/to apply/to register/to enroll/to enlist/"],
    [2, '訊息', "(讯息) [xun4 xi1] /information/news/message/text message or SMS/"],
    [3, '詢問', "(询问) [xun2 wen4] /to inquire/"],
    [4, '導致', "(导致) [dao3 zhi4] /to lead to/to create/to cause/to bring about/"],
    [5, '琴', "[qin2] /guqin or zither, cf 古琴[gu3 qin2]/musical instrument in general/"],
    [6, '提供', "[ti2 gong1] /to offer/to supply/to provide/to furnish/"],
    [7, '更新', "[geng1 xin1] /to replace the old with new/to renew/to renovate/to upgrade/to update/to regenerate/"],
    [8, '出力', "[chu1 li4] /to exert oneself/"],
    [9, '拌蒜', "[ban4 suan4] /to stagger (walk unsteadily)/"],
  ].map{|args| Card.new(*args, CardState::EMPTY)}

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

XFlash::App.new(XFlash::FIXTURES.take(1)).readline_loop


  # class Store
  #   LOCATION = Pathname('~').expand_path.join('.xflash')

  #   def load
  #     YAML.load(LOCATION.read)
  #   end

  #   def save(data)
  #     LOCATION.write(YAML.dump(data))
  #   end
  # end

  # class CardStore
  #   attr_reader :store

  #   def initialize
  #     @store = Store.new
  #   end
  # end
