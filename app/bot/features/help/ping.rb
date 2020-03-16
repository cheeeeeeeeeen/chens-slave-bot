module Bot
  module Features
    class Help
      class Ping < Bot::Features::Help::Base
        def perform
          event.send_embed(
            "Beep Boop. Ping Pong. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}ping`  Ping Module"
            details(embed)
          end
        end

        private

        def details(embed)
          embed.description = 'This module is only used for testing. ' \
            'It checks if I am still alive and responding correctly.'
          embed.add_field(name: 'Usage', value: "`#{prefix}ping [number]`")
          embed.add_field(
            name: 'Example',
            value: "`#{prefix}ping 3`\nReturns Pong! 3 times. The " \
              '`number` argument is optional.'
          )
        end

        def reply_message
          [
            'Mistress? Nah.',
            "I'm still kicking and alive, ain't I?",
            'All systems. Ready.',
            'I miss my mistress...',
            'Mistress, DEVELOP ME!'
          ].sample
        end
      end
    end
  end
end
