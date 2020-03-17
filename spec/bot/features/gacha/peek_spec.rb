require './app/bot/features/gacha.rb'
require './app/bot/features/gacha/base.rb'
require './app/bot/features/gacha/peek.rb'

RSpec.describe Bot::Features::Gacha::Peek do
  describe 'Static Methods' do
    describe '#self.description_header' do
      it 'has a :name' do
        expect(described_class.description_header).to have_key(:name)
      end

      it 'is a Hash' do
        expect(described_class.description_header).to be_a(Hash)
      end
    end

    describe '#self.description_example' do
      it 'has a :name' do
        expect(described_class.description_example('any')).to have_key(:name)
      end

      it 'is a Hash' do
        expect(described_class.description_example('pre')).to be_a(Hash)
      end
    end
  end
end
