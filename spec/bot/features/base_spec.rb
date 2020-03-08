RSpec.describe Bot::Features::Base do
  describe '#initialize' do
    it 'accepts a bot argument' do
      expect(described_class.new('hi').bot).to eq('hi')
    end
  end

  describe 'Discordrb Integration tests' do
    pending 'not yet coded'
  end
end
