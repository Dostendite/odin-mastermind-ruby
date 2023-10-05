key = []
4.times do
  key << rand(1..6)
end

puts "Key: #{key}"

def return_indicators(input_array, key)
  input_array.each_with_index do |_, idx|
    key.each do
      if input_array[idx] == key[idx]
        input_array[idx] = '!'
        key[idx] = nil
      end
    end
  end

  input_array.each_with_index do |_input_item, idx|
    key.each do |key_item|
      if input_array[idx] == key_item
        input_array[idx] = '*'
        key[key.find_index(key_item)] = nil
      end
    end
  end

  input_array.map! { |item| (0..6).include?(item) ? '?' : item }

  input_array
end

print 'Enter 4 numbers: '
input_array = gets.chomp.split('')[0..3]
input_array.map!(&:to_i)

p return_indicators(input_array, key)
