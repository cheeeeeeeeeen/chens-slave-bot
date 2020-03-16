module Bot
  module Features
    class Help
      class Gacha < Bot::Features::Help::Base
        def perform
          require_files
          event.send_embed(
            "I am a bot for simulating Gacha pulls. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}gacha`  Gacha Actions"
            commands_display(embed)
          end
        end

        private

        def commands_display(embed)
          action_list.sort.each do |action|
            Application.action_class('Bot::Features::Gacha', action)
                       .description(embed, prefix)
          end
        end

        def reply_message
          [
            'Here are the actions you can do in the Gacha module.',
            "You knew that, didn't you?",
            "I'm cool, so I will guide you.",
            "You can do this. Don't give up.",
            'These commands are not for the faint of heart, mind you.'
          ].sample
        end
      end
    end
  end
end
