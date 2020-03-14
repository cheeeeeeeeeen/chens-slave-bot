module Bot
  module Features
    class Item < Bot::Features::Base
      attr_reader :guild, :gacha_json

      def request_link
        "#{Application.database_link}/items"
      end

      private

      def feature(event, command, arguments)
        @guild = event.server
        build_gacha(arguments[0])
        super(event, command, arguments[1...arguments.count])
      end

      def build_gacha(key_name)
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
