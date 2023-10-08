# frozen_string_literal: true

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
      @computer.process_indicators(@game_board.latest_indicators)

      sleep 0.25
      check = game_over?
    end
  end

  private

  def game_over?
    check = @game_board.check_board_status
    if check == 'Victory'
      if @computer
        true
      else
        true
      end
    elsif check == 'Out of turns'
      true
    else
      false
    end
  end
end
