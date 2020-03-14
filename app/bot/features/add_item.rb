module Bot
  module Features
    class AddItem < Bot::Features::Base
      attr_reader :guild, :gacha_json

      private

      def action
        @bot.command :add_item do |event, key_name, item_name, chance|
          fetch_guild_and_gacha(event, key_name)
          create_item(item_name, chance)
          event.send_embed do |embed|
            embed.description =
              "Successfully created Item in #{gacha_json['name']}!"
          end
        end
      end

      def fetch_guild_and_gacha(event, key_name)
        @guild = event.server
        build_gacha(guild.id, key_name)
      end

      def create_item(item_name, chance)
        HTTParty.post(
          "#{Application.database_link}/items",
          body: {
            guild_id: guild.id,
            key_name: gacha_json['key_name'],
            name: item_name,
            chance: chance
          }
        )
      end

      def build_gacha(guild_id, key_name)
        @gacha_json = HTTParty.get(
          "#{Application.database_link}/gachas/#{key_name}",
          body: {
            guild_id: guild_id
          }
        )
        @gacha_json = @gacha_json['gacha']
      end
    end
  end
end
