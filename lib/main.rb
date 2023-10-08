# frozen_string_literal: true

require_relative 'knuth_algo'
require_relative 'board'
require_relative 'computer'
require_relative 'game'
require 'colorize'

game = Game.new
game.start_game
