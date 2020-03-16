module Bot
  module Features
    class Help
      class Prefix < Bot::Features::Help::Base
        def perform
          event.send_embed(
            reply_message
          ) do |embed|
            embed.title = "`#{prefix}ping`  Prefix Module"
            details(embed)
          end
        end

        private

        def details(embed)
          embed.description = 'This module is used for changing the ' \
            'command prefix for this server. Any prefix combinations are ' \
            'possible as long as they can be sent as a message.'
          embed.add_field(usage_details)
          embed.add_field(example_details)
        end

        def usage_details
          {
            name: 'Usage',
            value: "`#{prefix}prefix <new_prefix>`"
          }
        end

        def example_details
          {
            name: 'Example',
            value: "`#{prefix}prefix #{example_prefix}`\nThis sets the new " \
              "server prefix to `#{example_prefix}` for use with future " \
              'commands.'
          }
        end

        def reply_message
          [
            "Changing the server prefix is easy. Here's how.",
            "The server prefix is like how you look at life:\n" \
            "You want to change it if you don't find comfort in it.",
            "Command Prefix, eh? Everyone's favorite command.",
            "There's a saying that the server prefix can change your life."
          ].sample
        end

        def example_prefix
          return '!' if prefix == ';'

          ';'
        end
      end
    end
  end
end
