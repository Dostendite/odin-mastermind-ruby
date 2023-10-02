require 'colorize'

# Mastermind game board
class Board

  attr_reader :key

  def initialize
    @board = (Array.new(12) { Array.new(8, ' ') })
    @colors = { 1 => 'r', 2 =>  'g', 3 =>  'y',
                4 => 'b', 5 => 'm', 6 => 'w' }
    @key = generate_key
    @insert_counter = 0
  end

  def generate_key
    key = [1, 2, 3, 4, 5, 6].sample(4)
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
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '        MASTERMIND'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '  Guesses    |  Indicators'
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

  # play a turn and insert 4 colors
  def insert_colors(colors)
    @insert_counter -= 1

    colors.each_with_index do |color, idx|
      @board[@insert_counter][idx] = colors[idx]
    end

    inspect_colors
    print_board
  end

  # inspect the colors and return
  # the feedback on the last values of
  # the array
  def inspect_colors
    # fix indicators always
    # matching number
    # (learn how they really work first though)
    @board.each do |row|
      0.upto(3) do |idx|
        if row[idx] == @key[idx]
          row[idx + 4] = '!'
        elsif @key.include?(row[idx])
          row[idx + 4] = '*'
        else
          row[idx + 4] = '?'
        end
      end
    end
  end
end

def gen_random_colors
  [1, 2, 3, 4, 5, 6].sample(4)
end

my_board = Board.new
my_board.insert_colors(gen_random_colors)
puts "Key: #{my_board.key}"
