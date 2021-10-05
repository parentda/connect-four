# frozen_string_literal: true

class Board
  attr_reader :positions

  @@directions = {
    vertical: [[1, 0], [-1, 0]],
    horizontal: [[0, 1], [0, -1]],
    diagonal: [[1, 1], [-1, -1]],
    anti_diagonal: [[1, -1], [-1, 1]]
  }

  def initialize(height, width, streak)
    @height = height
    @width = width
    @streak = streak
    @previous_move = 0
    @positions = Array.new(width) { [] }
  end

  def valid_move?(column)
    column.between?(1, @width) && @positions[column - 1].length < @height
  end

  def full?
    @positions.all? { |column| column.length == @height }
  end

  def update_board(column, marker)
    @positions[column - 1] << marker
    @previous_move = column - 1
  end

  def display
    output = "\n\t"
    @height.times do |num|
      @positions.each do |column|
        output += "|#{column[@height - 1 - num] || ' '}"
      end
      output += "|\n\t"
    end
    output += "#{"\u203E" * 15}\n\t"
    @width.times { |num| output += " #{num + 1}" }
    output += "\n\n"

    puts output
  end

  def game_over?
    column = @previous_move
    row = @positions[column].length - 1
    marker = @positions[column][row]

    @@directions.each do |_key, direction|
      return true if streak_found?(column, row, direction, marker)
    end
    false
  end

  private

  def streak_found?(column, row, direction, marker)
    streak_length(column, row, direction[0], marker) +
      streak_length(column, row, direction[1], marker) - 1 >= @streak
  end

  def streak_length(column, row, vector, marker)
    unless column.between?(0, @width - 1) && row.between?(0, @height - 1) &&
             @positions[column][row] == marker
      return 0
    end

    streak_length(column + vector[0], row + vector[1], vector, marker) + 1
  end
end
