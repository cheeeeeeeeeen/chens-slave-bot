module Bot
  module Features
    class ModifyPrefix < Bot::Features::Base
      attr_reader :guild_id

      private

      def action
        @bot.command :modify_prefix do |event, new_prefix|
          fetch_guild(event)
          process(new_prefix)
          event.respond("Updated command prefix to `#{new_prefix}`")
        end
      end

      def fetch_guild(event)
        @guild_id = event.server.id
      end

      def process(prefix)
        HTTParty.post(
          "#{Application.database_link}/guilds/modify_prefix",
          body: {
            guild_id: guild_id,
            command_prefix: prefix
          }
        )
        @assembler.update_prefix_data(guild_id, prefix)
      end
    end
  end
end
