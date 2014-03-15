module XFlash
  class Deck < DelegateClass(Array)
    def expired_cards(time)
      select {|card| card.expired?(time) }
    end

    def new_cards
      select(&:new?)
    end

    def update_card(old, new)
      self.class.new(take(index(old)) + [new] + drop(index(old) + 1))
    end
  end
end
