class Board
  def initialize(height, width)
    @height = height
    @width = width
    @positions = Array.new(width) { [] }
  end

  def valid_move?(column)
    column.between?(0, @width - 1) && @positions[column - 1].length < @height
  end
end
