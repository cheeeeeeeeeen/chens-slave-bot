module Bot
  module Features
    class Help
      class Item < Bot::Features::Help::Base
        def perform
          require_files
          event.send_embed(
            "Items will always belong to a Gacha set. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}item`  Item Actions"
            commands_display(embed)
          end
        end

        private

        def commands_display(embed)
          action_list.sort.each do |action|
            Application.action_class('Bot::Features::Item', action)
                       .description(embed, prefix)
          end
        end

        def reply_message
          [
            "That's just fate.",
            'Here are the actions you can do...',
            "Don't even try cheating Item chances.",
            "I'm a hot topic, I know.",
            'Are you one of those cry babies?'
          ].sample
        end
      end
    end
  end
end
