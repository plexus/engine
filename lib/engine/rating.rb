module Engine
  class Rating < Struct.new(:timestamp, :rating)
    MAX_RATING = 3
    FAIL = 0
    HARD = 1
    GOOD = 2
    EASY = 3

    def neg_rating
      MAX_RATING - rating
    end

    def fail? ; rating == FAIL end
    def hard? ; rating == HARD end
    def good? ; rating == GOOD end
    def easy? ; rating == EASY end
  end
end
