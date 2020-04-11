module Bot
  module Incidents
    class Base
      attr_reader :bot, :assembler, :event

      def initialize(assembler_obj)
        @bot = assembler_obj.bot
        @assembler = assembler_obj
      end

      def insert
        bot.send(listener_type, attributes) do |event_obj|
          @event = event_obj
          action if condition
        end
      end

      def attributes
        {}
      end

      def condition
        true
      end

      private

      def listener_type
        'message'
      end

      def action; end
    end
  end
end
