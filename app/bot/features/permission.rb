module Bot
  module Features
    class Permission < Bot::Features::Base
      attr_reader :guild, :affected_feature, :action, :prefix

      def saved
        @saved ||= false
      end

      def administrator
        @administrator ||= begin
          (@permissions = Discordrb::Permissions.bits([:administrator]))
        end
      end

      def request_link
        "#{Application.database_link}/permissions"
      end

      def self.options(prefix)
        {
          description: 'A command for setting permissions for each ' \
            'module. If a module accepts an action argument, then ' \
            "one can set the permissions per action.\nTake note that " \
            'the permission module does not set permission levels ' \
            "of users or channels.\nFor more information, type " \
            "`#{prefix}help permission`."
        }
      end

      private

      def initialize_permissions(_, _); end

      def feature(event, affected_feature, arguments)
        return unless authorized?(event)

        assign_variables(event.server, affected_feature, arguments)
        save_permission_in_database
        respond(event)
      end

      def assign_variables(server, feature, arguments)
        @guild = server
        @prefix = assembler.fetch_prefix(guild.id.to_s)
        @affected_feature = validate_feature(feature)
        if contains_actions?
          @action = arguments[0]
          @permissions = arguments[1..-1]
        else
          @action = nil
          @permissions = arguments
        end
      end

      def contains_actions?
        Dir["./app/bot/features/#{@affected_feature}/*"].count.positive?
      end

      def save_permission_in_database
        response = HTTParty.post(
          request_link,
          body: {
            guild_id: guild.id,
            feature_name: affected_feature,
            action_name: action,
            key_names: permissions.join(',')
          }
        )
        (@saved = response['permission'] != 'error')
      end

      def respond(event)
        if saved
          event.respond('Permissions are saved.')
        else
          event.respond("Your command looks abnormal. Use `#{prefix}help" \
                        ' permission` for proper guidance.')
        end
      end

      def permitted_by_role?(user)
        result = false
        user.roles.each do |role|
          result = (role.permissions.bits & administrator) == administrator
          break if result
        end
        result
      end

      def validate_feature(feature)
        return feature if assembler.feature_list.include?(feature.capitalize)

        nil
      end
    end
  end
end
