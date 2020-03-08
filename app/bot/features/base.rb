module Bot
  module Features
    class Base
      attr_reader :bot

      def initialize(bot_obj)
        @bot = bot_obj
      end

      def insert
        action
      end

      private

      def action; end
    end
  end
end
