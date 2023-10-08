# frozen_string_literal: true

# Computer player class
class Computer
  include KnuthAlgo

  def initialize
    @possible_codes = generate_possible_codes
    @current_guess = 1122
  end

  def make_guess
    integer_to_array(@current_guess)
  end

  def process_indicators(latest_indicators)
    prune_codes(latest_indicators)
    puts "Codes left: #{@possible_codes.length}"
    @current_guess = @possible_codes.sample
  end

  def prune_codes(latest_indicators)
    @possible_codes.each do |code|
      possible_key_feedback = compare_codes(@current_guess, code)
      if possible_key_feedback != latest_indicators
        @possible_codes.delete(code)
      end
    end
  end
end
