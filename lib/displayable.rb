module Displayable
  def segment_break_prompt
    puts "\n#{'+---' * 30}+"
  end

  def introduction_prompt(board)
    puts <<~HEREDOC

      Welcome to Connect Four!

      The rules are simple: Be the first player to mark 4 spaces in a row (vertically, horizontally, or diagonally)

      The board is shown below:
    HEREDOC

    board.display
    puts <<~HEREDOC
      Two players are required, and to add a marker to a column, simply input the number indicating that column at the bottom of the board above.

      Before we get started, we need to know who will be playing today.

    HEREDOC
  end

  def game_start_prompt(board, players)
    puts <<~HEREDOC

      Thank you! 
      
      #{players.reduce('') { |string, player| string += "#{player.name}, your marker is #{player.marker}\n" }}  
      Let's get started.
    HEREDOC
    board.display
  end

  def name_prompt(number)
    print "Player #{number + 1}, please enter your name: "
  end

  def player_input_prompt(player)
    print "#{player.name}, please select an unfilled column: "
  end

  def invalid_selection_prompt(player)
    print "Sorry #{player.name}, that is not a valid selection. Please ensure you select an unfilled column: "
  end

  def win_prompt(player)
    puts "Congratulations #{player.name}, you have won the game!\n\n"
  end

  def tie_prompt
    puts "The game ends in a draw!\n\n"
  end
end
