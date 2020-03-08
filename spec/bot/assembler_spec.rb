RSpec.describe Bot::Assembler do
  let(:assembler) { described_class.new }
  let(:assembler_with_args) do
    described_class.new(
      key: 'rofl',
      client_id: 'grab'
    )
  end

  describe '#initialize' do
    context 'without arguments specified' do
      before do
        stub_const(
          'ENV',
          ENV.to_hash.merge(
            'SECRET_BOT_TOKEN' => 'lmao',
            'DISCORD_APP_CLIENT_ID' => 'client'
          )
        )
      end

      it 'initializes @token based on ENV' do
        expect(assembler.token).to eq('lmao')
      end

      it 'initializes @client_id based on ENV' do
        expect(assembler.client_id).to eq('client')
      end
    end

    context 'with arguments specified' do
      it 'initializes @token based on the argument' do
        expect(assembler_with_args.token).to eq('rofl')
      end

      it 'initializes @client_id based on the argument' do
        expect(assembler_with_args.client_id).to eq('grab')
      end
    end
  end

  describe 'Discordrb Integration tests' do
    pending 'not yet coded'
  end
end
