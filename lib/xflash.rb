# -*- coding: utf-8 -*-
require 'pathname'
require 'yaml'
require 'readline'

module XFlash
  class Card < Struct.new(:id, :front, :back, :difficulty, :iteration, :last_shown)
    def interval(i = iteration)
      case i
      when 0
        0
      when 1
        1
      when 2
        6
      else
        interval(i-1) * difficulty
      end
    end

    def rate(zero_to_five)
      self.iteration += 1
      complement = 5 - zero_to_five
      self.difficulty = self.difficulty + (0.1 - complement * (0.08 + complement * 0.02))
    end

    def inspect
      "<%s %s>" % [front, %w[iteration difficulty interval].map {|k| "%s: %s" % [k, send(k)] }.join(', ')]
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
  ].map{|args| Card.new(*args, 2.5, 0)}


  class CardStore
    attr_reader :store

    def initialize
      @store = Store.new
    end
  end

  class Store
    LOCATION = Pathname('~').expand_path.join('.xflash')

    def load
      YAML.load(LOCATION.read)
    end

    def save(data)
      LOCATION.write(YAML.dump(data))
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

XFlash::App.new(XFlash::FIXTURES).readline_loop
