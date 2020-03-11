module Bot
  module Features
    class DeleteGacha < Bot::Features::Base
      attr_reader :guild

      private

      def action
        @bot.command :delete_gacha do |event, key_name|
          fetch_guild(event)
          destroy_gacha(key_name)
          event.respond("Deleted that worthless scam!")
        end
      end

      def fetch_guild(event)
        @guild = event.server
      end

      def destroy_gacha(key_name)
        HTTParty.delete(
          "#{Application.database_link}/guilds/#{guild.id}/gachas/#{key_name}"
        )
      end
    end
  end
end
