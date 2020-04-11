module Bot
  module Features
    class Base
      attr_reader :bot, :assembler, :action, :permissions

      def initialize(assembler_obj)
        @bot = assembler_obj.bot
        @assembler = assembler_obj
      end

      def insert(is_public)
        bot.command bare_feature_name do |event, command, *arguments|
          feature(event, command, arguments)
          nil
        end
        assembler.feature_list << bare_class_name if is_public
      end

      def self.options(_)
        {
          description: '*No description specified...*'
        }
      end

      private

      def feature(event, command, filtered_arguments)
        return unless authorized?(event, command)

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

      def authorized?(event, command = nil)
        case event.channel.type
        when 0
          server_authorization(event, command)
        when 1
          listen_dm?(event)
        else
          false
        end
      end

      def server_authorization(event, command)
        initialize_permissions(event.server.id, command)
        return true if permitted_by_role?(event.user)

        event.respond('You are unauthorized to use this command.')
        false
      end

      def listen_dm?(_)
        false
      end
    end
  end
end
