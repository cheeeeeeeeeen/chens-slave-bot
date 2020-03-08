require_relative '../../../app/bot/features/ping'

RSpec.describe Bot::Features::Ping do
  let(:ping) { described_class.new('a bot', 'an assembler') }

  describe 'Process Methods' do
    describe '#process_reply' do
      context 'when argument passed is less than 2' do
        it 'returns Pong!' do
          expect(ping.send(:process_reply, 1)).to eq('Pong!')
        end
      end

      context 'when argument passed is greater than 1' do
        it 'returns Pong!' do
          expect(ping.send(:process_reply, 2)).to match(/Pong 0!\WPong 1!/)
        end
      end
    end

    describe '#multi_pong' do
      let(:pong) { ping.send(:multi_pong, 4) }

      it 'returns the same number of pongs according to argument given' do
        expect(pong).to match(/Pong 3/)
      end

      it 'does not display the pong number of the argument' do
        expect(pong).not_to match(/Pong 4/)
      end
    end
  end
end
