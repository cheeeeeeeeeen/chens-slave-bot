module Bot
  module Features
    class Gacha < Bot::Features::Base
      attr_reader :guild

      def request_link
        "#{Application.database_link}/gachas"
      end

      private

      def feature(event, command, arguments)
        super(command)
        fetch_guild(event)
        action.new(self, event, arguments).perform
      end

      def fetch_guild(event)
        @guild = event.server
      end
    end
  end
end
