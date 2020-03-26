module Bot
  module Features
    class Help
      class Gacha < Bot::Features::Help::Base
        def perform
          require_files
          embed_first_part
          embed_second_part
        end

        private

        def commands_display(embed, range)
          action_list.sort[range].each do |action|
            Application.action_class('Bot::Features::Gacha', action)
                       .description(embed, prefix)
            permission_display(embed, action, action != action_list.max)
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

        def embed_first_part
          event.send_embed(
            "I am a bot for simulating Gacha pulls. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}gacha`  Gacha Actions"
            commands_display(embed, 0...3)
          end
        end

        def embed_second_part
          event.send_embed do |embed|
            commands_display(embed, 3..-1)
          end
        end
      end
    end
  end
end
