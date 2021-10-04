# frozen_string_literal: true
require_relative 'displayable'
class Game
  include Displayable

  attr_reader :players

  def initialize(num_players)
    @num_players = num_players
    @players = []
    @markers = ["\e[31m\u25CF\e[0m", "\e[33m\u25CF\e[0m"]
  end

  def play
    game_setup
    player_turns
    game_end
  end

  def create_player(number)
    name_prompt(number)
    name = gets.chomp
    @players << Player.new(name, @markers[number - 1])
  end
end
