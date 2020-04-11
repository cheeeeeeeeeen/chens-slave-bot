module Bot
  module Incidents
    class RelayAllDirectMessages < Bot::Incidents::Base
      private

      def action
        Discordrb::API::Channel.create_message(
          assembler.header_token,
          channel_id,
          sent_dm_message
        )
      end

      def condition
        event.channel.type == 1 && event.user.id != master_id
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

      def sent_dm_message
        "**Direct Message** - <@#{event.user.id}> (#{event.user.id})\n" \
        "\"#{event.message.content}\"\n" \
        "Shortcut Reply: ```!puppet direct #{event.user.id} ```"
      end

      def master_id
        @master_id ||= ENV['MASTER_ID'].to_i
      end
    end
  end
end
