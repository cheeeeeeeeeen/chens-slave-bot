module Bot
  module Features
    class Help < Bot::Features::Base
      def self.options(prefix)
        {
          description: 'A command for seeking help. It can accept an ' \
            'action argument that is a listed module in this help ' \
            'message. One may also filter the actions by adding action ' \
            "arguments.\ne.g.\n- `#{prefix}help permission`\n- " \
            "`#{prefix}help gacha create upload`"
        }
      end

      private

      def feature(event, command, arguments)
        return unless authorized?(event)
        return if !command.nil? &&
                  !assembler.feature_list.include?(command.capitalize)

        initialize_action(command)
        action.new(event, command, arguments, assembler).perform
      end

      def initialize_action(command)
        if command.nil? || command == ''
          require_relative "#{bare_class_name.downcase}/base"
          @action = Object.const_get("#{self.class.name}::Base")
        else
          super(command)
        end
      end

      def server_authorization(_, _)
        true
      end
    end
  end
end
