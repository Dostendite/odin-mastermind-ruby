# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'computer.rb'
require_relative 'game.rb'
require 'colorize'

game = Game.new
game.start_game
