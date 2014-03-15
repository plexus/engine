module XFlash
  class Card < Struct.new(:id, :front, :back, :card_state)
    extend Forwardable
    def_delegators :card_state, :factor, :interval, :expired?

    def new?
      card_state.empty?
    end

    def rate(rating)
      next_card_state = card_state << Rating.new(Time.now, rating)
      self.class.new(id, front, back, next_card_state)
    end

    def inspect
      "<Card #{front} #{card_state.inspect}>"
    end
  end
end
