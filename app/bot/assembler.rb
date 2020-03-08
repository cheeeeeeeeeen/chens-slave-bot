require_relative 'features/base'

module Bot
  class Assembler
    attr_reader :bot, :token, :prefix, :client_id

    def initialize(key: nil, client_id: nil, prefix: '!')
      @token = key || ENV['SECRET_BOT_TOKEN']
      @prefix = prefix
      @client_id = client_id || ENV['DISCORD_APP_CLIENT_ID']
    end

    def create_bot
      @bot = Discordrb::Commands::CommandBot.new(
        token: token,
        client_id: client_id,
        prefix: prefix
      )
    end

    def install(feature)
      Application.feature_class(feature).new(@bot).insert
    end

    def deploy
      @bot.run
    end
  end
end
