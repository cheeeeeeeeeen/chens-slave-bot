module Bot
  module Features
    class ListGacha < Bot::Features::Base
      attr_reader :guild, :gachas_json

      private

      def action
        @bot.command :list_gacha do |event|
          fetch_guild(event)
          fetch_gachas
          event.send_embed do |embed|
            embed.description = all_gachas
          end
        end
      end

      def fetch_guild(event)
        @guild = event.server
      end

      def fetch_gachas
        @gachas_json = HTTParty.get(
          "#{Application.database_link}/guilds/#{guild.id}/gachas"
        )
        @gachas_json = @gachas_json['gachas']
      end

      def all_gachas
        data = ''
        gachas_json.each do |gacha|
          data += "\n**#{gacha['name']}** (#{gacha['key_name']})"
        end
        data[0] = ''
        data
      end
    end
  end
end
