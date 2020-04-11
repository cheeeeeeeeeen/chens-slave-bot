require_relative 'features/base'
require_relative 'incidents/base'

module Bot
  class Assembler
    attr_reader :bot, :token, :client_id, :header_token

    def initialize(key: nil, client_id: nil)
      @token = key || ENV['SECRET_BOT_TOKEN']
      @header_token = "Bot #{@token}"
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

    def server_version
      response = HTTParty.get("#{Application.database_link}/details")
      response['version']
    end

    def install(feature, is_public = true)
      Application.feature_class(feature).new(self).insert(is_public)
    end

    def listen(incident)
      Application.incident_class(incident).new(self).insert
    end

    def deploy
      @bot.run
    end

    private

    def prefix_process
      proc do |msg|
        prefix = fetch_prefix(msg.channel.server&.id)
        msg.content[prefix.size..-1] if msg.content.start_with?(prefix)
      end
    end
  end
end
