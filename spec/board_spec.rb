# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  def set_full(test_board)
    test_board.instance_variable_set(
      :@positions,
      Array.new(7) { Array.new(6, 'X') }
    )
  end

  def set_partial(test_board)
    test_board.instance_variable_set(
      :@positions,
      Array.new(7) { Array.new(5, 'X') }
    )
  end

  subject(:board) { described_class.new(6, 7, 4) }

  describe '#valid_move?' do
    context 'when entering an invalid column' do
      it 'returns false' do
        invalid_move1 = board.valid_move?(0)
        invalid_move2 = board.valid_move?(8)
        expect(invalid_move1).to be false
        expect(invalid_move2).to be false
      end
    end

    context 'when entering a valid column on a partially full board' do
      it 'returns true' do
        set_partial(board)
        valid_move = board.valid_move?(3)
        expect(valid_move).to be true
      end
    end

    context 'when entering a valid column on a full board' do
      it 'returns false' do
        set_full(board)
        invalid_move = board.valid_move?(3)
        expect(invalid_move).to be false
      end
    end
  end

  describe '#full?' do
    context 'when board is empty' do
      it 'returns false' do
        expect(board).to_not be_full
      end
    end

    context 'when board is partially full' do
      it 'returns false' do
        set_partial(board)
        expect(board).to_not be_full
      end
    end

    context 'when board is full' do
      it 'returns true' do
        set_full(board)
        expect(board).to be_full
      end
    end
  end

  describe '#update_board' do
    context 'when given a valid column' do
      it 'adds marker to that column' do
        column = 3
        symbol = 'X'
        expect { board.update_board(column, symbol) }.to change {
          board.positions[column - 1].length
        }.by(1)
        expect(board.positions[column - 1].last).to eq(symbol)
      end
    end
  end

  describe '#game_over?' do
    context 'when board is empty' do
      it 'is not game over' do
        expect(board).to_not be_game_over
      end
    end

    context 'when board is partially-filled' do
      it 'is not game over' do
        board.instance_variable_set(:@previous_move, 3)
        board.instance_variable_set(
          :@positions,
          [
            %w[X X X],
            %w[Y Y Y],
            %w[X X X],
            %w[Y X Y X],
            %w[X Y X],
            %w[Y Y Y],
            %w[X X X]
          ]
        )
        expect(board).to_not be_game_over
      end
    end

    context 'when there is a vertical streak' do
      it 'is game over' do
        board.instance_variable_set(:@previous_move, 0)
        board.instance_variable_set(
          :@positions,
          [
            %w[X X X X],
            %w[Y Y Y],
            %w[X X X],
            %w[Y X Y X],
            %w[X Y X],
            %w[Y Y Y],
            %w[X X X]
          ]
        )
        expect(board).to be_game_over
      end
    end

    context 'when there is a horizontal streak' do
      it 'is game over' do
        board.instance_variable_set(:@previous_move, 4)
        board.instance_variable_set(
          :@positions,
          [
            %w[X X X X],
            %w[Y Y Y],
            %w[X X X],
            %w[Y Y X Y],
            %w[X Y X],
            %w[Y Y X X],
            %w[X X X]
          ]
        )
        expect(board).to be_game_over
      end
    end

    context 'when there is a diagonal streak' do
      it 'is game over' do
        board.instance_variable_set(:@previous_move, 2)
        board.instance_variable_set(
          :@positions,
          [
            %w[Y X],
            %w[Y Y Y],
            %w[X X Y],
            %w[Y Y X Y],
            %w[X Y X],
            %w[Y Y X X],
            %w[X X X]
          ]
        )
        expect(board).to be_game_over
      end
    end

    context 'when there is an anti-diagonal streak' do
      it 'is game over' do
        board.instance_variable_set(:@previous_move, 3)
        board.instance_variable_set(
          :@positions,
          [
            %w[Y X X X],
            %w[Y Y Y],
            %w[X X X],
            %w[Y Y X Y],
            %w[X Y Y],
            %w[Y Y X X],
            %w[Y X X]
          ]
        )
        expect(board).to be_game_over
      end
    end
  end
end
