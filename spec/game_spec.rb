# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new(2) }
  describe '#create_player' do
    context 'when creating a new player' do
      before do
        allow(game).to receive(:name_prompt)
        allow(game).to receive(:gets).and_return('Name')
      end

      it 'sends a call to Player class' do
        expect(Player).to receive(:new).once
        game.create_player(1)
      end

      it 'adds new player to players array' do
        expect { game.create_player(1) }.to change { game.players.length }.by(1)
      end
    end
  end

  describe '#player_input' do
    let(:valid_input) { '3' }
    let(:invalid_input) { 'A' }

    context 'when player input is valid' do
      before { allow(game).to receive(:gets).and_return(valid_input) }

      it 'stops loop and does not display error message' do
        expect(game).not_to receive(:invalid_selection_prompt)
        game.player_input
      end

      it 'returns valid column number' do
        column = game.player_input
        expected_output = valid_input.to_i
        expect(column).to eq(expected_output)
      end
    end

    context 'when player inputs an incorrect value once, then a valid input' do
      before do
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end
      it 'completes loop and displays error message once' do
        expect(game).to receive(:invalid_selection_prompt).once
        game.player_input
      end
    end

    context 'when player inputs two incorrect values, then a valid input' do
      before do
        allow(game).to receive(:gets).and_return(
          invalid_input,
          invalid_input,
          valid_input
        )
      end
      it 'completes loop and displays error message twice' do
        expect(game).to receive(:invalid_selection_prompt).twice
        game.player_input
      end
    end
  end
end
