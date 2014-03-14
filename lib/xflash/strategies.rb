module XFlash
  class BaseStrategy < Struct.new(:history, :data_point)
    extend Forwardable
    def_delegators :history, :iteration, :streak, :factor, :interval
    def_delegators :data_point, :fail?, :rating, :neg_rating

    def next_streak
      fail? ? 0 : streak + 1
    end
  end

  class SuperMemoStrategy < BaseStrategy
    INITIAL_INTERVALS = [1, 6]

    def next_factor
      [factor + (0.1 - neg_rating * (0.28 + neg_rating * 0.02)), 1.3].max
    end

    def next_interval
      INITIAL_INTERVALS.fetch(next_streak) do
        interval * next_factor
      end
    end
  end

  class AnkiStrategy < BaseStrategy
    INITIAL_INTERVALS = [1, 4]

    def next_factor
      [factor + [0.15, 0, -0.15, -0.3].fetch(neg_rating) {0}, 1.3].max
    end

    def next_interval
      INITIAL_INTERVALS.fetch(next_streak) do
        interval * next_factor
      end
    end
  end
end
