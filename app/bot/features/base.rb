module Bot
  module Features
    class Base
      attr_reader :bot, :assembler, :action, :permissions

      def initialize(bot_obj, assembler_obj)
        @bot = bot_obj
        @assembler = assembler_obj
      end

      def insert
        bot.command bare_feature_name do |event, command, *arguments|
          feature(event, command, arguments)
          nil
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
        initialize_permissions(event.server.id, command)
        return nil unless permitted_by_role?(event.user)

        initialize_action(command)
        action.new(self, event, filtered_arguments).perform
      end

      def initialize_permissions(guild_id, command)
        response = HTTParty.get(
          "#{Application.database_link}/permissions/show",
          body: { guild_id: guild_id, action_name: command,
                  feature_name: bare_feature_name }
        )
        @permissions =
          Discordrb::Permissions.bits(
            response['key_names']&.split(',')&.map(&:to_sym) || []
          )
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

      def permitted_by_role?(user)
        result = false
        user.roles.each do |role|
          result = (role.permissions.bits & @permissions) == @permissions
          break if result
        end
        result
      end
    end
  end
end
