# frozen_string_literal: true
require_relative 'displayable'
class Game
  include Displayable

  attr_reader :players

  def initialize(num_players)
    @num_players = num_players
    @players = []
    @markers = ["\e[31m\u25CF\e[0m", "\e[33m\u25CF\e[0m"]
    @board = Board.new(6, 7, 4)
  end

  def play
    game_setup
    player_turns
    game_end
  end

  def game_setup
    game_start_prompt
    @num_players.times { |num| create_player(num) }
  end

  def create_player(number)
    name_prompt(number)
    name = gets.chomp
    @players << Player.new(name, @markers[number - 1])
  end

  def player_input
    while (column = gets.chomp.to_i)
      break column if @board.valid_move?(column)

      invalid_selection_prompt
    end
  end
end
