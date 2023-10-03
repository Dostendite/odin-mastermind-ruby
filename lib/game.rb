require 'colorize'

# Game object
class Game
  def initialize
    @game_board = Board.new
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
    # select_player
  end

  def player_play_turn
    print 'Enter four colors'
    puts " (#{'[1]'.colorize(:red)}#{'[2]'.colorize(:green)}" + 
           "#{'[3]'.colorize(:yellow)}#{'[4]'.colorize(:blue)}" +
           "#{'[5]'.colorize(:magenta)}#{'[6]'.colorize(:white)})"
    color_inputs = gets.chomp.split('')
    color_inputs.map(&:to_i)
    # @game_board.colors_to_integers(color_array)
  end

  def play_turn(color_array)
    @turns_played += 1
    @game_board.insert_colors(color_array)
  end

  # main game functions
  def play_game
    @game_board.print_board
    loop do
      # temporary method
      play_turn(player_play_turn)

      break if game_over?
    end
  end

  private

  def game_over?
    system 'clear'
    @game_board.print_board
    check = @game_board.check_board_status
    if check == 'Victory'
      puts 'You won!'
      true
    elsif check == 'Out of turns'
      puts "Out of turns!\nThe secret key was #{@game_board.key}!"
      true
    else
      false
    end
  end

  def check_board_status(board_status)
    if board_status == 'Victory'
      game_over('Victory')
      'Victory'
    elsif board_status == 'Out of turns'
      game_over('Out of turns')
      'Victory'
    end
  end
end

# Game board (For Game object)
class Board
  attr_reader :key, :insert_counter

  def initialize
    @board = (Array.new(12) { Array.new(8, ' ') })
    @colors = { 'red' => 1, 'green' => 2, 'yellow' => 3,
                'blue' => 4, 'magenta' => 5, 'white' => 6 }
    @insert_counter = 0
    @key = generate_key
  end

  # play a turn and insert 4 colors
  def insert_colors(color_array)
    @insert_counter -= 1

    color_array.each_with_index do |_color, idx|
      @board[@insert_counter][idx] = color_array[idx]
    end

    inspect_colors
    print_board
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
      'Out of turns'
    elsif @board[@insert_counter][0..3] == @key
      'Victory'
    end
  end

  # def colors_to_integers(color_array)
  #   # ['blue', 'green', 'yellow', 'red'] => [4, 2, 3, 1]
  #   color_array.each_with_index do |_, idx|
  #     color_array[idx] = @colors[color_array[idx]]
  #   end
  #   color_array
  # end

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

  def inspect_colors
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
      row[4..7] = row[4..7].shuffle
    end
  end

  def generate_key
    [1, 2, 3, 4, 5, 6].sample(4)
  end
end

game = Game.new
game.play_game
