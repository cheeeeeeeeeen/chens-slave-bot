require_relative 'features/base'

module Bot
  class Assembler
    attr_reader :bot, :token, :client_id

    def initialize(key: nil, client_id: nil)
      @token = key || ENV['SECRET_BOT_TOKEN']
      @client_id = client_id || ENV['DISCORD_APP_CLIENT_ID']
    end

    def create_bot
      @bot = Discordrb::Commands::CommandBot.new(
        token: token,
        client_id: client_id,
        prefix: prefix_process,
        help_command: false
      )
    end

    def feature_list
      @feature_list ||= []
    end

    def fetch_prefix(guild_id)
      response = HTTParty.get(
        "#{Application.database_link}/guilds/show",
        body: { guild_id: guild_id }
      )
      if response['guild'].nil?
        '!'
      else
        response['guild']['command_prefix']
      end
    end

    def install(feature)
      Application.feature_class(feature).new(@bot, self).insert
    end

    def deploy
      @bot.run
    end

    private

    def prefix_process
      proc do |msg|
        prefix = fetch_prefix(msg.channel.server.id)
        msg.content[prefix.size..-1] if msg.content.start_with?(prefix)
      end
    end
  end
end
