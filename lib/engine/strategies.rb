module Engine
  class BaseStrategy < Struct.new(:card_state, :data_point)
    extend Forwardable
    def_delegators :card_state, :data_points, :iteration, :streak, :factor, :interval
    def_delegators :data_point, :fail?, :rating, :neg_rating
  end

  class SuperMemoStrategy < BaseStrategy
    INITIAL_INTERVALS = [1, 6]

    def next_streak
      fail? ? 0 : streak + 1
    end

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
    LEARNING_INTERVALS = [0, 1, 10, 25].map(&:to_f)
    INITIAL_INTERVALS  = [1, 2].map {|min| min*60*24 }.map(&:to_f)
    LEARNING_STEPS     = LEARNING_INTERVALS.length - 1

    def learning?
      steps_to_graduation > 0
    end

    def steps_to_graduation
      data_points.map(&:rating).inject(LEARNING_STEPS, :-)
    end

    def next_streak
      fail? || learning? ? 0 : streak + 1
    end

    def next_factor
      if learning?
        factor
      else
        [factor + [0.15, 0, -0.15, -0.3].fetch(neg_rating) {0}, 1.3].max
      end
    end

    # Good enough for our purposes, and stable for a given card-state
    def pseudo_rand
      data_point.timestamp.to_f % 1
    end

    def next_interval
      if learning?
        LEARNING_INTERVALS.fetch(-steps_to_graduation)
      else
        INITIAL_INTERVALS.fetch(next_streak) do
          interval * next_factor
        end
      end * (0.8 + pseudo_rand * 0.4) # 0.8 - 1.2
    end
  end
end
