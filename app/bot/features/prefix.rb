module Bot
  module Features
    class Prefix < Bot::Features::Base
      attr_reader :guild_id, :same_prefix

      def self.options(_)
        {
          description: 'A command for changing the command prefix ' \
            'for use of this server.' \
        }
      end

      private

      def feature(event, new_prefix, _)
        return unless authorized?(event)

        fetch_guild(event)
        process(new_prefix)
        event.respond(verdict_response(new_prefix))
      end

      def fetch_guild(event)
        @guild_id = event.server.id
      end

      def process(prefix)
        return if same_prefix?(prefix)

        HTTParty.post(
          "#{Application.database_link}/guilds/modify_prefix",
          body: {
            guild_id: guild_id,
            command_prefix: prefix
          }
        )
      end

      def same_prefix?(prefix)
        @same_prefix = prefix == assembler.fetch_prefix(guild_id.to_s)
      end

      def verdict_response(prefix)
        if same_prefix
          "Updated from `#{prefix}` to `#{prefix}` the command prefix.\n" \
          "It doesn't seem to look any different, " \
          'but the new one is vastly superior!'
        else
          "Updated to `#{prefix}` the command prefix."
        end
      end
    end
  end
end
