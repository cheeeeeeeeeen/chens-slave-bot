require_relative 'features/base'

module Bot
  class Assembler
    attr_reader :bot, :token, :client_id

    def initialize(key: nil, client_id: nil)
      @token = key || ENV['SECRET_BOT_TOKEN']
      @client_id = client_id || ENV['DISCORD_APP_CLIENT_ID']
    end

    def create_bot
      # fetch_server_prefixes
      @bot = Discordrb::Commands::CommandBot.new(
        token: token,
        client_id: client_id,
        prefix: prefix_process,
        help_command: false
      )
    end

    # def prefix_data
    #   @prefix_data ||= {}
    # end

    # def update_prefix_data(guild_id, new_prefix)
    #   prefix_data[guild_id.to_s] = new_prefix.to_s
    # end

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

    # def permission_data
    #   @permission_data ||= {}
    # end

    # def update_permission_data(guild_id, feature, action, permissions)
    #   guild_hash = permission_data[guild_id.to_s]
    #   guild_hash[feature] = {} if guild_hash[feature].nil?
    #   guild_hash[feature][action] = permissions.map(&:to_sym)
    # end

    def install(feature)
      Application.feature_class(feature).new(@bot, self).insert
    end

    def deploy
      @bot.run
    end

    private

    # def fetch_server_prefixes
    #   response = HTTParty.get("#{Application.database_link}/guilds")
    #   response['guilds'].each do |guild|
    #     update_prefix_data(guild['discord_id'], guild['command_prefix'])
    #   end
    # end

    # def fetch_server_permissions
    #   response = request_permissions
    #   response['permissions'].each do |permission|
    #     update_permission_data(
    #       permission['guild_discord_id'],
    #       permission['feature_name'],
    #       permission['action_name'],
    #       permission['key_names'].split(',')
    #     )
    #   end
    # end

    # def request_permissions
    #   HTTParty.get(
    #     "#{Application.database_link}/permissions",
    #     body: { id: 'all' }
    #   )
    # end

    def prefix_process
      proc do |msg|
        prefix = fetch_prefix(msg.channel.server.id)
        msg.content[prefix.size..-1] if msg.content.start_with?(prefix)
      end
    end
  end
end
