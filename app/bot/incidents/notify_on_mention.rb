module Bot
  module Incidents
    class NotifyOnMention < Bot::Incidents::Base
      private

      def listener_type
        'mention'
      end

      def action
        Discordrb::API::Channel.create_message(
          assembler.header_token,
          channel_id,
          mention_notify
        )
      end

      def channel_id
        @channel_id ||= begin
          response = Discordrb::API::User.create_pm(
            assembler.header_token,
            master_id
          )
          JSON.parse(response)['id'].to_i
        end
      end

      def mention_notify
        "**Mention/Ping** - <@#{event.user.id}> (#{event.user.id})\n" \
        "#{mention_source}\n" \
        "\"#{event.message.content}\"\n" \
        "Shortcut Reply: #{shortcut_command}"
      end

      def mention_source
        case event.channel.type
        when 0
          "From Server #{event.server.name} (#{event.server.id})"
        when 1
          'From Direct Message'
        else
          '*Unknown Source*'
        end
      end

      def shortcut_command
        case event.channel.type
        when 0
          "```!puppet channel #{event.channel.id} ```"
        when 1
          "```!puppet direct #{event.user.id} ```"
        else
          '*Not supported.*'
        end
      end

      def master_id
        @master_id ||= ENV['MASTER_ID'].to_i
      end
    end
  end
end
