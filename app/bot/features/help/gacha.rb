module Bot
  module Features
    class Help
      class Gacha < Bot::Features::Help::Base
        def perform
          require_files
          event.send_embed(
            'I am a bot for simulating Gacha pulls. Here are the ' \
            'actions you can do in the Gacha module.'
          ) do |embed|
            embed.title = "Gacha Actions  `#{prefix}gacha`"
            commands_display(embed)
          end
        end

        private

        def commands_display(embed)
          action_list.each do |action|
            Application.action_class("Bot::Features::Gacha", action)
                       .description(embed, prefix)
          end
        end
      end
    end
  end
end
