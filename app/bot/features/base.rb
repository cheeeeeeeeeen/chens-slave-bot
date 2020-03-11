module Bot
  module Features
    class Base
      attr_reader :bot, :assembler

      def initialize(bot_obj, assembler_obj)
        @bot = bot_obj
        @assembler = assembler_obj
      end

      def insert
        action
      end

      def build_words(words_array)
        words_array.join(' ')
      end

      private

      def action; end
    end
  end
end
