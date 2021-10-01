# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#valid_move?' do
    context ' with a new board' do
      subject(:empty_board) { described_class.new(6, 7) }
      context 'when entering a valid column' do
        it 'returns true' do
          valid_move = empty_board.valid_move?(3)
          expect(valid_move).to be true
        end
      end

      context 'when entering an invalid column' do
        it 'returns false' do
          invalid_move1 = empty_board.valid_move?(-1)
          invalid_move2 = empty_board.valid_move?(8)
          expect(invalid_move1).to be false
          expect(invalid_move2).to be false
        end
      end
    end

    context 'when entering a valid column on a full board' do
      subject(:full_board) { described_class.new(6, 7) }
      it 'returns false' do
        full_board.instance_variable_set(
          :@positions,
          Array.new(7) { Array.new(6, 'X') }
        )
        invalid_move = full_board.valid_move?(3)
        expect(invalid_move).to be false
      end
    end

    context 'when entering a valid column on a partially full board' do
      subject(:full_board) { described_class.new(6, 7) }
      it 'returns true' do
        full_board.instance_variable_set(
          :@positions,
          Array.new(7) { Array.new(5, 'X') }
        )
        valid_move = full_board.valid_move?(3)
        expect(valid_move).to be true
      end
    end
  end
end
