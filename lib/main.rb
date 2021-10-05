# frozen_string_literal: true

require_relative 'game'

def game_restart
  print 'Enter 1 to start a new game. Enter any other key to quit: '
  gets.chomp.to_i == 1
end

loop do
  game = Game.new(2)
  game.play
  break unless game_restart
end
