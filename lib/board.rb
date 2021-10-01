class Board
  attr_reader :positions

  def initialize(height, width)
    @height = height
    @width = width
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
  end
end
