require 'colorize'
require 'pry-byebug'

# Mastermind game board
class Board

  attr_reader :key

  def initialize
    @board = (Array.new(12) { Array.new(8, ' ') })
    @key = generate_key
    @insert_counter = 0
  end

  def generate_key
    [1, 2, 3, 4, 5, 6].sample(4)
  end

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

  def print_board
    system 'clear'
    @board.each do |row|
      # first 4 colors
      row[0..3].each do |color|
        print_color(color)
      end
      print ' | '
      # guess indicators
      row[4..7].each do |color|
        print_color(color)
      end
      print "\n"
    end
  end

  def check_board_status
    if @insert_counter == -12
      'Game over'
    elsif @board[@insert_counter][0..3] == @key
      'Victory'
    end
  end

  def colors_to_integers(color_array)
    color_array.each_with_index do |color, idx|
      case color
      when 'red'
        color_array[idx] = 1
      when 'green'
        color_array[idx] = 2
      when 'yellow'
        color_array[idx] = 3
      when 'blue'
        color_array[idx] = 4
      when 'magenta'
        color_array[idx] = 5
      when 'white'
        color_array[idx] = 6
      end
    end
    color_array
  end

  def manual_insert_colors
    print "Enter the four colors to play\n(separated by spaces): "
    color_array = gets.chomp.split
    colors_to_integers(color_array)
    insert_colors(color_array)
  end

  # play a turn and insert 4 colors
  def insert_colors(color_array)
    @insert_counter -= 1

    color_array.each_with_index do |_color, idx|
      @board[@insert_counter][idx] = color_array[idx]
    end

    inspect_colors
    print_board
    check_board_status
  end

  # inspect the colors and return
  # the feedback on the last values of
  # the array
  def inspect_colors
    # fix indicators always
    # matching number
    # (learn how they really work first though)
    @board.each_with_index do |row|
      indicators = Array.new(4)
      0.upto(3) do |idx|
        if row[idx] == @key[idx]
          row[idx + 4] = '!'
        elsif @key.include?(row[idx])
          row[idx + 4] = '*'
        else
          row[idx + 4] = '?'
        end
      end
      # if row[-1] == 'shuffled'
      #   next
      # else
      #   row[4..7] = row[4..7].shuffle
      #   row.push('shuffled')
      # end
    end
  end
end

def gen_random_colors
  [1, 2, 3, 4, 5, 6].sample(4)
end

board = Board.new
game_on = true
board.print_board

while game_on
  turn = board.manual_insert_colors
  if turn == 'Game over'
    puts "Game over, you're out of turns!"
    break
  elsif turn == 'Victory'
    puts 'You guessed the code, you win!'
    break
  end
end
