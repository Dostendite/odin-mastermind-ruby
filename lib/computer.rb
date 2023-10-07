# frozen_string_literal: true

# Computer player class
class Computer
  attr_reader :indicator_amount, :winning_combination

  def initialize
    @indicator_amount = 0
    @winning_combination = []
    @guesses_made = []
    @rainbow_colors = [[1, 1, 1, 1],
                       [2, 2, 2, 2],
                       [3, 3, 3, 3],
                       [4, 4, 4, 4],
                       [5, 5, 5, 5],
                       [6, 6, 6, 6]]
  end

  def delete_rainbow_color(color)
    @rainbow_colors.each do |row|
      @rainbow_colors.delete(row) if row.include?(color)
    end
  end

  def guess_rainbow
    guess = @rainbow_colors.sample
    delete_rainbow_color(guess[0])
    @guesses_made << guess[0]
    guess
  end

  def make_guess
    if @indicator_amount == 0
      guess_rainbow
    elsif @indicator_amount < 4
      guess = guess_rainbow
      if @indicator_amount > 0
        @indicator_amount.times do |i|
          guess[i] = @winning_combination[i]
        end
        guess
      end
    else
      guess = @winning_combination.shuffle

      if @guesses_made.include?(guess)
        while @guesses_made.include?(guess)
          guess = guess = @winning_combination.shuffle
        end
      end
      guess
    end
  end

  def process_indicators(board_indicators)
    score = 0
    board_indicators.each do |indicator|
      if indicator == '!'
        score += 1
      elsif indicator == '*'
        score += 1
      end
    end

    score -= @winning_combination.length
    @indicator_amount += score
    score.times do
      @winning_combination << @guesses_made[-1]
    end
  end
end
