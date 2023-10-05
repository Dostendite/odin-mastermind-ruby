key = []
4.times do
  key << rand(1..6)
end

puts "Key: #{key}"

def return_indicators(input_array, key)
  # iterate through the input
  # then iterate through the key

  # each_with_index only on the first one
  # because we can share the index

  # check every input number against
  # the key and look for exact matches first
  # if so, replace input[idx] with '!' and set
  # key[idx] to nil to bomb it

  # we can even optimize this into a map very easily

  # after that nested loop, do another run,
  # and check them the same way
  # if a number from input is the same as
  # a number from the key (doesn't matter the position)
  # bomb them both! (can use .find_index)
  # doesn't matter if it's not the exact position because
  # it will return the right asterisks anyways
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
