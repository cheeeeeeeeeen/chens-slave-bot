module Bot
  module Features
    class Puppet
      class Channel < Bot::Features::Puppet::Base
        def perform
          Discordrb::API::Channel.create_message(
            puppet.assembler.header_token,
            channel_id,
            message
          )
        rescue Discordrb::Errors::NoPermission
          event.respond("I can't talk in <##{channel_id}> (#{channel_id}).")
        end

        private

        def channel_id
          parameters[0].to_i
        end

        def message
          parameters[1..-1].join(' ')
        end
      end
    end
  end
end
