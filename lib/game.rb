require 'colorize'

# Game object
class Game
  def initialize
    @game_board = Board.new
  end

  def select_player
    print 'Do you want to create the code or to break it? (C/B): '
    selection = gets.chomp
    if selection == 'C'
      play_game_computer
    else
      play_game_player
    end
  end

  def start_game
    # introduce the player to the game
    # and explain not only the
    # gamemode, but also show the colors
    # and indicators
    system 'clear'
    select_player
  end

  def set_player_key
    print 'Enter key for the computer to solve: '
    player_code = gets.chomp.split('')
    player_code.map!(&:to_i)
    @game_board.key = player_code
  end

  def fetch_player_guess
    print 'Enter four colors'
    puts " (#{'[1]'.colorize(:red)}#{'[2]'.colorize(:green)}" + 
           "#{'[3]'.colorize(:yellow)}#{'[4]'.colorize(:blue)}" +
           "#{'[5]'.colorize(:magenta)}#{'[6]'.colorize(:white)})"
    color_inputs = gets.chomp.split('')
    color_inputs.map(&:to_i)
  end

  def play_game_player
    @game_board.print_board

    check = game_over?
    until check
      @game_board.make_guess(fetch_player_guess)
      check = game_over?
    end
  end

  def play_game_computer
    @computer = Computer.new
    set_player_key
    @game_board.print_board

    check = game_over?

    until check
      @game_board.make_guess(@computer.make_guess)
      check = game_over?
      p @computer.fetch_board_info
    end
  end

  private

  def game_over?
    check = @game_board.check_board_status
    if check == 'Victory'
      if @computer
        puts 'The computer wins!'
        true
      else
        puts 'You win!'
        true
      end
    elsif check == 'Out of turns'
      puts "Out of turns!\nThe secret key was #{@game_board.key}!"
      true
    else
      false
    end
  end
end

# Game board (For Game object)
class Board
  attr_accessor :key, :indicators

  def initialize
    @board = (Array.new(12) { Array.new(8, ' ') })
    @colors = { 'red' => 1, 'green' => 2, 'yellow' => 3,
                'blue' => 4, 'magenta' => 5, 'white' => 6 }
    @insert_counter = 0
    @key = generate_random_key
    # latest indicators
    @indicators = nil
  end

  # play a turn and insert 4 colors
  def make_guess(color_array)
    @insert_counter -= 1

    color_array.each_with_index do |_color, idx|
      @board[@insert_counter][idx] = color_array[idx]
    end

    print_board
  end

  def print_board
    system 'clear'
    update_board
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
    update_indicators
  end

  def check_board_status
    if @board[@insert_counter][0..3] == @key
      'Victory'
    elsif @insert_counter == -12
      'Out of turns'
    end
  end

  private

  def update_indicators
    @indicators = @board[@insert_counter][4..7]
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

  def update_board
    @board.each do |row|

      duplicate_key = []
      duplicate_key.replace(@key)

      # find exact matches first
      0.upto(3) do |idx|
        if row[idx] == duplicate_key
          duplicate_key.delete_at(idx)
          row[idx + 4] = '!'
        end
      end

      0.upto(3) do |idx|
        if duplicate_key.include?(row[idx])
          duplicate_key.delete_at(idx)
          row[idx + 4] = '*'
        else
          row[idx + 4] = '?'
        end
      end
    end
  end

  def generate_random_key
    key = []
    4.times do
      key << rand(1..6)
    end
    key
  end
end

# Computer player class
class Computer
  def generate_random_key
    key = []
    4.times do
      key << rand(1..6)
    end
    key
  end

  def make_guess
    latest_indicators = fetch_board_info

    # returns the next guess
    generate_random_key
  end

  private

  def fetch_board_info(board_indicators)
    p board_indicators
  end
end

game = Game.new
game.start_game
