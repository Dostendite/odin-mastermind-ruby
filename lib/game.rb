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
    # and explain the gamemode and
    # the colors and indicators
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
    print 'Enter guess: '
    puts " (#{'[1]'.colorize(:red)}#{'[2]'.colorize(:green)}" + 
           "#{'[3]'.colorize(:yellow)}#{'[4]'.colorize(:blue)}" +
           "#{'[5]'.colorize(:magenta)}#{'[6]'.colorize(:white)})"
    color_inputs = gets.chomp.split('')[0..3]
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
      sleep 0.25
      check = game_over?
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
    @board = (Array.new(12) { Array.new(4, ' ') })
    @indicators = (Array.new(12) { Array.new(4, ' ') })
    @colors = { 'red' => 1, 'green' => 2, 'yellow' => 3,
                'blue' => 4, 'magenta' => 5, 'white' => 6 }
    @insert_counter = 0
    @key = generate_random_key
  end

  # play a turn and insert 4 colors
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
    key = []
    4.times do
      key << rand(1..6)
    end
    key
  end
end

# Computer player class
class Computer
  attr_reader :scores, :possible_keys

  def initialize
    @scores = { 1 => 0, 2 => 0, 3 => 0,
                4 => 0, 5 => 0, 6 => 0 }
    @current_guesses = 0
    @possible_keys = generate_possible_keys
    @latest_key = nil
  end

  def make_guess
    update_computer_key_random
    @current_guesses += 1
    @latest_key
  end

  def update_computer_key_random
    @latest_key = []
    4.times do
      @latest_key << rand(1..6)
    end
  end

  def process_indicators(board_indicators)
    score = 0
    board_indicators.each do |indicator|
      if indicator == '!'
        score += 1
      elsif indicator == '*'
        score += 1
      else # indicator = ?
        score -= 1
      end
    end
  end

  private
  
  def generate_possible_keys
    possible_keys = []
    start_code = 1110

    while start_code < 6666
      ary_version = start_code.to_s.split('').map!(&:to_i).reverse!
      if ary_version.include?(7)
        index_of_seven = ary_version.find_index(7)
        if ary_version[index_of_seven..index_of_seven + 2] == [7, 6, 6]
          start_code += 444
          possible_keys << start_code
        elsif ary_version[index_of_seven..index_of_seven + 1] == [7, 6]
          start_code += 44
          possible_keys << start_code
        else
          start_code += 4
          possible_keys << start_code
        end
      else
        start_code += 1
        possible_keys << start_code
      end
    end

    possible_keys.each do |key|
      possible_keys.delete(key) if key.to_s.split('').map!(&:to_i).include?(7)
    end
    
    possible_keys
  end
end

game = Game.new
game.start_game
