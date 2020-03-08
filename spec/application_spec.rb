RSpec.describe Application do
  describe 'static methods' do
    describe '#environment' do
      it 'fetches the environment value' do
        expect(described_class.environment).to eq('test')
      end
    end

    describe '#production?' do
      context 'when the environment is production' do
        before do
          stub_const(
            'ENV',
            ENV.to_hash.merge(
              'APP_ENVIRONMENT' => 'production'
            )
          )
        end

        it 'returns true if the environment is on production' do
          expect(described_class.production?).to be_truthy
        end
      end

      context 'when the environment is not production' do
        it 'returns false if the environment is not on production' do
          expect(described_class.production?).to be_falsey
        end
      end
    end

    describe '#test?' do
      context 'when the environment is test' do
        it 'returns true if the environment is on test' do
          expect(described_class.test?).to be_truthy
        end
      end

      context 'when the environment is not test' do
        before do
          stub_const(
            'ENV',
            ENV.to_hash.merge(
              'APP_ENVIRONMENT' => 'production'
            )
          )
        end

        it 'returns false if the environment is not on test' do
          expect(described_class.test?).to be_falsey
        end
      end
    end

    describe '#development?' do
      context 'when the environment is development' do
        before do
          stub_const(
            'ENV',
            ENV.to_hash.merge(
              'APP_ENVIRONMENT' => 'development'
            )
          )
        end

        it 'returns true if the environment is on development' do
          expect(described_class.development?).to be_truthy
        end
      end

      context 'when the environment is not development' do
        it 'returns false if the environment is not on development' do
          expect(described_class.development?).to be_falsey
        end
      end
    end

    describe '#discord_api_version' do
      before do
        stub_const(
          'ENV',
          ENV.to_hash.merge(
            'DISCORD_API_VERSION' => '103'
          )
        )
      end

      it 'returns the version number' do
        expect(described_class.discord_api_version).to eq('103')
      end
    end

    describe '#api_link' do
      before do
        stub_const(
          'ENV',
          ENV.to_hash.merge(
            'DISCORD_API_VERSION' => '10307'
          )
        )
      end

      it 'returns a link with the correct version number' do
        expect(described_class.api_link).to(
          eq('https://discordapp.com/api/v10307')
        )
      end
    end

    describe '#feature_class' do
      it 'loads the class' do
        described_class.feature_class('Base')
        expect(Bot::Features::Base).to be_truthy
      end

      it 'returns the class' do
        expect(described_class.feature_class('Base')).to eq(Bot::Features::Base)
      end
    end

    describe '#file_name' do
      it 'converts the specified class name into a file name format' do
        expect(described_class.file_name('AugmentCore')).to eq('augment_core')
      end
    end
  end

  describe 'Requires' do
    it 'requires dotenv/load' do
      expect(ENV['DISCORD_API_VERSION']).not_to be_nil
    end

    it 'requires gems from Gemfile' do
      expect(Discordrb::Bot).not_to be_nil
    end
  end
end
