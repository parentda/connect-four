class Board
  attr_accessor :positions

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

  def display
    visualize = ''
    @height.times do |num|
      @positions.each do |column|
        visualize += "|#{column[@height - 1 - num] || ' '}"
      end
      visualize += "|\n\t"
    end
    visualize += "#{"\u203E" * 15}\n\t"
    @width.times { |num| visualize += " #{num + 1}" }

    puts <<-HEREDOC

        #{visualize}
    HEREDOC
  end
end
