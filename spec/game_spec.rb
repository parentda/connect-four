# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  describe '#create_player' do
    subject(:game) { described_class.new(2) }
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
end
