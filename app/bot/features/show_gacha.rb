module Bot
  module Features
    class ShowGacha < Bot::Features::Base
      attr_reader :guild, :gacha_json

      private

      def action
        @bot.command :show_gacha do |event, key_name|
          fetch_guild(event)
          show_gacha(key_name)
          event.send_embed do |embed|
            embed.add_field(name: '**Gacha Name**', value: gacha_json['name'])
            embed.add_field(name: '**Gacha Command**', value: gacha_json['key_name'])
          end
        end
      end

      def fetch_guild(event)
        @guild = event.server
      end

      def show_gacha(key_name)
        @gacha_json = HTTParty.get(
          "#{Application.database_link}/gachas/#{key_name}",
          body: {
            guild_id: guild.id
          }
        )
        @gacha_json = @gacha_json['gacha']
      end
    end
  end
end
