module Bot
  module Features
    class Gacha < Bot::Features::Base
      attr_reader :guild, :key_name

      def request_link
        "#{Application.database_link}/gachas"
      end

      def self.options(_)
        {
          description: 'A command which allows for Gacha data ' \
            "management for this server.\n" \
            "It accepts a set of actions listed below:\n" \
            '`all`, `create`, `delete`, `peek`, `pull`'
        }
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
