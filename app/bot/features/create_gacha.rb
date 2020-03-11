module Bot
  module Features
    class CreateGacha < Bot::Features::Base
      attr_reader :guild

      private

      def action
        @bot.command :create_gacha do |event, key_name, *name|
          fetch_guild(event)
          create_gacha(key_name, build_words(name))
          event.send_embed do |embed|
            embed.description = "Successfully created Gacha for #{guild.name}!"
          end
        end
      end

      def fetch_guild(event)
        @guild = event.server
      end

      def create_gacha(key_name, name)
        HTTParty.post(
          "#{Application.database_link}/guilds/#{guild.id}/gachas",
          body: {
            key_name: key_name,
            name: name
          }
        )
      end
    end
  end
end
