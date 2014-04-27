module Srsly
  class CLI
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
        input = Readline.readline("#{card.data.first} > ", true)
        exit unless input
        case input
        when /s/, ""
          puts card.data.last
        when /[0-5]/
          rate_card(input.to_i)
          next_card
        end
      end
    end
  end
end
