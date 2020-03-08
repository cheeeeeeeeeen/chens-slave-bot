RSpec.describe Bot::Features::Base do
  describe '#initialize' do
    it 'accepts a bot argument' do
      expect(described_class.new('hi', 'hello').bot).to eq('hi')
    end

    it 'accepts a assembler argument' do
      expect(described_class.new('hi', 'hello').assembler).to eq('hello')
    end
  end

  describe 'Discordrb Integration tests' do
    pending 'not yet coded'
  end
end
