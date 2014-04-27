module Srsly
  class Deck < DelegateClass(Array)
    %w[select map reject grep reverse sort_by sort].each do |array_method|
      define_method array_method do |*args, &blk|
        self.class.new(super(*args, &blk))
      end
    end

    def expired_cards(time)
      select {|card| card.expired?(time) }.sort_by do |card|
        [card.expired_for_seconds(time), -card.last_shown.to_i]
      end.reverse
    end

    def new_cards
      select(&:new?)
    end

    def update_card(old, new)
      self.class.new(take(index(old)) + [new] + drop(index(old) + 1))
    end
  end
end
