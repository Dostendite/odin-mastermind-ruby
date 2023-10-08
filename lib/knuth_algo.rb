# Knuth Algorithm Module
module KnuthAlgo
  def generate_possible_codes
    possible_codes = []
    start_code = 1110

    while start_code < 6666
      ary_version = start_code.to_s.split('').map!(&:to_i).reverse!
      if ary_version.include?(7)
        index_of_seven = ary_version.find_index(7)
        if ary_version[index_of_seven..index_of_seven + 2] == [7, 6, 6]
          start_code += 444
          possible_codes << start_code
        elsif ary_version[index_of_seven..index_of_seven + 1] == [7, 6]
          start_code += 44
          possible_codes << start_code
        else
          start_code += 4
          possible_codes << start_code
        end
      else
        start_code += 1
        possible_codes << start_code
      end
    end

    possible_codes.each do |key|
      possible_codes.delete(key) if key.to_s.split('').map!(&:to_i).include?(7)
    end

    possible_codes
  end

  def compare_codes(guess, code)
    guess = integer_to_array(guess)
    code = integer_to_array(code)
    result = []

    4.times do |idx|
      if code[idx] == guess[idx]
        code[idx] = '!'
        guess[idx] = nil
      end
    end

    code.each_with_index do |_, idx|
      guess.each_with_index do |_, sub_idx|
        if code[idx] == guess[sub_idx]
          code[idx] = '*'
          guess[sub_idx] = nil
        end
      end
    end

    code.map! { |item| (0..6).include?(item) ? '?' : item }
    code.sort!
    code
  end

  def integer_to_array(integer)
    integer_copy = integer
    integer_copy.to_s.split('').map!(&:to_i)
  end
end
