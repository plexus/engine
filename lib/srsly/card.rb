module Srsly
  class Card < Struct.new(:data, :card_state)
    extend Forwardable
    def_delegators :card_state, :factor, :iteration, :streak, :interval, :expired?, :expired_for_seconds, :last_shown, :data_points

    def new?
      card_state.empty?
    end

    def rate(rating)
      next_card_state = card_state << Rating.new(Time.now, rating)
      self.class.new(data, next_card_state)
    end

    def lapsed?
      streak == 0
    end

    def inspect
      "<Card #{data.inspect} #{card_state.inspect}>"
    end
  end
end
