# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new(2) }
  before { game.instance_variable_set(:@board, instance_double(Board)) }

  describe '#create_player' do
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

  describe '#player_input' do
    let(:valid_input) { '3' }
    let(:invalid_input) { 'A' }
    before do
      allow(game.board).to receive(:valid_move?)
        .with(valid_input.to_i)
        .and_return(true)
      allow(game.board).to receive(:valid_move?)
        .with(invalid_input.to_i)
        .and_return(false)
    end

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

  describe '#game_setup' do
    before do
      allow(game).to receive(:name_prompt)
      allow(game).to receive(:gets).and_return('Name')
    end

    it 'sets @current_player' do
      game.game_setup
      expect(game.current_player).to_not be nil
    end
  end

  describe '#player_turn' do
    before do
      allow(game).to receive(:player_input).and_return(3)
      game.instance_variable_set(
        :@current_player,
        instance_double(Player, name: 'Name', marker: 'X')
      )
    end

    it 'updates board' do
      allow(game.board).to receive(:display)
      expect(game.board).to receive(:update_board).with(2, 'X').once
      game.player_turn
    end

    it 'displays board' do
      allow(game.board).to receive(:update_board)
      expect(game.board).to receive(:display).once
      game.player_turn
    end
  end

  describe '#switch_player' do
    let(:p1) { instance_double(Player, name: 'p1', marker: 'X') }
    let(:p2) { instance_double(Player, name: 'p2', marker: 'O') }
    before do
      game.instance_variable_set(:@players, [p1, p2])
      game.instance_variable_set(:@current_player, p1)
    end

    context 'when current player is Player 1 and one switch occurs' do
      it 'switches to Player 2' do
        game.switch_player
        expect(game.current_player.name).to eq('p2')
        expect(game.players.last.name).to eq('p1')
      end
    end

    context 'when current player is Player 1 and two switches occur' do
      it 'switches back to Player 1' do
        2.times { game.switch_player }
        expect(game.current_player.name).to eq('p1')
        expect(game.players.last.name).to eq('p2')
      end
    end
  end

  describe '#game_loop' do
    before do
      allow(game).to receive(:player_turn)
      allow(game).to receive(:switch_player)
    end

    context 'when board.full? is true' do
      before { allow(game.board).to receive(:full?).and_return(true) }

      it 'stops loop and does not switch players' do
        expect(game).to_not receive(:switch_player)
        game.game_loop
      end
    end

    context 'when board.full? is false three times' do
      before do
        allow(game.board).to receive(:game_over?).and_return(false)
        allow(game.board).to receive(:full?).and_return(
          false,
          false,
          false,
          true
        )
      end
      it 'calls switch_players three times' do
        expect(game).to receive(:switch_player).exactly(3).times
        game.game_loop
      end
    end

    context 'when board.game_over? is true' do
      before do
        allow(game.board).to receive(:full?).and_return(false)
        allow(game.board).to receive(:game_over?).and_return(true)
      end

      it 'stops loop and does not switch players' do
        expect(game).to_not receive(:switch_player)
        game.game_loop
      end
    end

    context 'when board.game_over? is false five times' do
      before do
        allow(game.board).to receive(:full?).and_return(false)
        allow(game.board).to receive(:game_over?).and_return(
          false,
          false,
          false,
          false,
          false,
          true
        )
      end
      it 'calls switch_players five times' do
        expect(game).to receive(:switch_player).exactly(5).times
        game.game_loop
      end
    end
  end
end
