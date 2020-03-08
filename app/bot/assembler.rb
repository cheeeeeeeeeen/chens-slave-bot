require_relative 'features/base'

module Bot
  class Assembler
    attr_reader :bot, :token, :client_id

    def initialize(key: nil, client_id: nil)
      @token = key || ENV['SECRET_BOT_TOKEN']
      @client_id = client_id || ENV['DISCORD_APP_CLIENT_ID']
    end

    def create_bot
      fetch_server_prefixes
      @bot = Discordrb::Commands::CommandBot.new(
        token: token,
        client_id: client_id,
        prefix: prefix_process
      )
    end

    def prefix_data
      @prefix_data ||= {}
    end

    def update_prefix_data(guild_id, new_prefix)
      prefix_data[guild_id.to_s] = new_prefix.to_s
    end

    def install(feature)
      Application.feature_class(feature).new(@bot, self).insert
    end

    def deploy
      @bot.run
    end

    private

    def fetch_server_prefixes
      response = HTTParty.get("#{Application.database_link}/guilds")
      store_prefix_data(response['guilds'])
    end

    def store_prefix_data(json)
      json.each do |guild|
        update_prefix_data(guild['discord_id'], guild['command_prefix'])
      end
    end

    def prefix_process
      proc do |msg|
        prefix = prefix_data[msg.channel.server.id.to_s] || '!'
        msg.content[prefix.size..-1] if msg.content.start_with?(prefix)
      end
    end
  end
end
