module Bot
  module Features
    class Base
      attr_reader :bot, :assembler, :action

      def initialize(bot_obj, assembler_obj)
        @bot = bot_obj
        @assembler = assembler_obj
      end

      def insert
        bot.command bare_feature_name do |event, command, *arguments|
          feature(event, command, arguments)
        end
        assembler.feature_list << bare_class_name
      end

      def self.options(_)
        {
          description: '*No description specified...*'
        }
      end

      private

      def feature(event, command, filtered_arguments)
        initialize_action(command)
        action.new(self, event, filtered_arguments).perform
      end

      def initialize_action(command)
        require_relative "#{bare_class_name.downcase}/base"
        @action = Application.action_class(self.class.name, command)
      end

      def bare_class_name
        self.class.name.split('::').last
      end

      def bare_feature_name
        Application.file_name(self.class.name).split('/').last.to_sym
      end
    end
  end
end
