module XFlash

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

    def last_shown
      data_points.to_a.last.timestamp
    end

    def expired?(time)
      (!empty? && data_point.fail?) || expired_for_seconds(time) > 0
    end

    def expired_for_seconds(time)
      empty? ? 0 : [time - last_shown - interval * 60, 0].max
    end

    def iteration ; empty? ? START[:iteration] : parent.iteration + 1   end
    def streak    ; empty? ? START[:streak]    : strategy.next_streak   end
    def factor    ; empty? ? START[:factor]    : strategy.next_factor   end
    def interval  ; empty? ? START[:interval]  : strategy.next_interval end

    def inspect
      "<#{self.class} iteration: %d, streak: %d, factor: %.2f, interval: %.2f>" % [iteration, streak, factor, interval]
    end
  end
end
