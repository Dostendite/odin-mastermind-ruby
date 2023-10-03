require 'colorize'

# Game object
class Game
  def initialize
    @board = [board.new]
    @key = generate_key
    @player = select_player
    @turns_played = 0
  end

  def select_player
    # have player choose
    # if they want to be the code maker
    # or the code breaker
  end
  
  def game_introduction
    # introduce the player to the game
    # and explain not only the
    # gamemode, but also show the colors
    # and indicators
    select_player
  end

  def play_turn
    @turns_played += 1

  end

  def play_game
    # main game function
  end

  private

  def generate_key
    [1, 2, 3, 4, 5, 6].sample(4)
  end
end

# Game board (For Game object)
class Board
  attr_reader :key, :insert_counter
  def initialize
    @board = (Array.new(12) { Array.new(8, ' ') })
    @colors = {'red' => 1, 'green' => 2, 'yellow' => 3,
               'blue' => 4, 'magenta' => 5, 'white' => 6}
    @insert_counter = 0
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

  def colors_to_integers(color_array)
    # ['blue', 'green', 'yellow', 'red'] => [4, 2, 3, 1]
    color_array.each_index do |idx|
      color_array[idx] = @colors[color_array[idx]]
    end
    color_array
  end

  def inspect_colors
    @board.each do |row|
      0.upto(3) do |idx|
        case row[idx]
        when @key[idx]
          row[idx + 4] = '!'
        when @key.include?(row[idx])
          row[idx + 4] = '*'
        else
          row[idx + 4] = '?'
        end
      end
    end
  end
end

game = Game.new
