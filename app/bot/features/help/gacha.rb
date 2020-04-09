module Bot
  module Features
    class Help
      class Gacha < Bot::Features::Help::Base
        def perform
          require_files
          if action_filter.count <= action_list_half
            embed_all
          else
            embed_first_part
            embed_second_part
          end
        end

        def action_filter
          @action_filter ||= begin
            intersection = action_list & arguments
            if intersection.empty?
              action_list
            else
              intersection
            end
          end
        end

        private

        def commands_display(embed, range)
          action_filter.sort[range].each do |action|
            Application.action_class('Bot::Features::Gacha', action)
                       .description(embed, prefix)
            permission_display(embed, action, action != action_filter.max)
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

        def embed_all
          event.send_embed(
            "Displaying only some of Gacha actions. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}gacha`  Gacha Actions"
            commands_display(embed, 0..-1)
          end
        end

        def embed_first_part
          event.send_embed(
            "I am a bot for simulating Gacha pulls. #{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}gacha`  Gacha Actions"
            commands_display(embed, 0...action_filter_half)
          end
        end

        def embed_second_part
          event.send_embed do |embed|
            commands_display(embed, action_filter_half..-1)
          end
        end

        def action_filter_half
          @action_filter_half ||= action_filter.count / 2
        end

        def action_list_half
          @action_list_half ||= action_list.count / 2
        end
      end
    end
  end
end
