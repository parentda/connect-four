# frozen_string_literal: true
require_relative 'displayable'
class Game
  include Displayable

  attr_reader :players, :current_player, :game_over, :board

  def initialize(num_players)
    @num_players = num_players
    @players = []
    @current_player = nil
    @game_over = false
    @markers = ["\e[31m\u25CF\e[0m", "\e[33m\u25CF\e[0m"]
    @board = Board.new(6, 7, 4)
  end

  def play
    game_setup
    game_loop
    game_end
  end

  def game_setup
    game_start_prompt
    @num_players.times { |num| create_player(num) }
    @current_player = @players.first
  end

  def create_player(number)
    name_prompt(number)
    name = gets.chomp
    @players << Player.new(name, @markers[number - 1])
  end

  def player_input
    while (column = gets.chomp.to_i)
      return column if @board.valid_move?(column)

      invalid_selection_prompt
    end
  end

  def player_turn
    column = player_input
    @board.update_board(column - 1, @current_player.marker)
    @board.display
  end

  def game_loop
    until @board.full?
      player_turn
      return @game_over = true if @board.game_over?

      switch_player
    end
  end

  def switch_player
    @players.rotate!
    @current_player = @players.first
  end

  def game_end
    @game_end ? win_prompt : tie_prompt
  end
end
