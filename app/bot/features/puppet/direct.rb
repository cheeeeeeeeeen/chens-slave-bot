module Bot
  module Features
    class Puppet
      class Direct < Bot::Features::Puppet::Base
        def perform
          Discordrb::API::Channel.create_message(
            puppet.assembler.header_token,
            channel_id,
            message
          )
        rescue Discordrb::Errors::NoPermission
          event.respond("I can't talk to <@#{recipient_id}> (#{recipient_id}).")
        end

        private

        def channel_id
          @channel_id ||= begin
            response = Discordrb::API::User.create_pm(
              puppet.assembler.header_token,
              recipient_id
            )
            JSON.parse(response)['id'].to_i
          end
        end

        def recipient_id
          parameters[0].to_i
        end

        def message
          parameters[1..-1].join(' ')
        end
      end
    end
  end
end
