module Bot
  module Features
    class Gacha < Bot::Features::Base
      attr_reader :guild, :key_name, :name

      def request_link
        "#{Application.database_link}/gachas"
      end

      private

      def feature(event, command, arguments)
        @guild = event.server
        @key_name = arguments[0]
        super(event, command, arguments[1...arguments.count])
      end
    end
  end
end
