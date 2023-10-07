# frozen_string_literal: true

# Game board (For Game object)
class Board
  attr_accessor :key, :indicators

  def initialize
    @board = (Array.new(12) { Array.new(4, ' ') })
    @indicators = (Array.new(12) { Array.new(4, ' ') })
    @colors = { 'red' => 1, 'green' => 2, 'yellow' => 3,
                'blue' => 4, 'magenta' => 5, 'white' => 6 }
    @insert_counter = 0
    @key = generate_random_key
  end

  def make_guess(color_array)
    @insert_counter -= 1

    color_array.each_with_index do |_color, idx|
      @board[@insert_counter][idx] = color_array[idx]
      @indicators[@insert_counter][idx] = color_array[idx]
    end

    update_indicators
    print_board
  end

  def update_indicators
    key_duplicate = []
    key_duplicate.replace(key)

    # can probably optimize this using map with index
    @indicators[@insert_counter].each_with_index do |_, idx|
      key_duplicate.each do
        if @indicators[@insert_counter][idx] == key_duplicate[idx]
          @indicators[@insert_counter][idx] = '!'
          key_duplicate[idx] = nil
        end
      end
    end

    @indicators[@insert_counter].each_with_index do |_, idx|
      key_duplicate.each do |key_item|
        if @indicators[@insert_counter][idx] == key_item
          @indicators[@insert_counter][idx] = '*'
          key_duplicate[key_duplicate.find_index(key_item)] = nil
        end
      end
    end

    @indicators[@insert_counter].map! { |item| (0..6).include?(item) ? '?' : item }
    @indicators[@insert_counter].sort!
  end

  def latest_indicators
    @indicators[@insert_counter]
  end

  def print_board
    system 'clear'
    12.times do |idx|
      @board[idx].each do |number|
        print_color(number)
      end
      print ' | '
      @indicators[idx].each do |indicator|
        print_color(indicator)
      end
      puts
    end
  end

  def check_board_status
    if @board[@insert_counter] == @key
      'Victory'
    elsif @insert_counter == -12
      'Out of turns'
    end
  end

  private

  def print_color(color)
    case color
    when 1
      print '[1]'.colorize(:red)
    when 2
      print '[2]'.colorize(:green)
    when 3
      print '[3]'.colorize(:yellow)
    when 4
      print '[4]'.colorize(:blue)
    when 5
      print '[5]'.colorize(:magenta)
    when 6
      print '[6]'.colorize(:white)
    when ' '
      print '[ ]'
    when '?'
      print '[?]'.colorize(:grey)
      # color is in key but
      # in the wrong position
    when '*'
      print '[*]'.on_white
      # color is in the correct
      # position
    when '!'
      print '[!]'.on_red
    end
  end 

  def generate_random_key
    [rand(1..6), rand(1..6), rand(1..6), rand(1..6)] 
  end
end
