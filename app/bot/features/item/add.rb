module Bot
  module Features
    class Item
      class Add < Bot::Features::Item::Base
        def perform
          create_item
          event.send_embed do |embed|
            embed.description =
              "Successfully created Item in #{item.gacha_json['name']}!"
          end
        end

        def chance
          @chance ||= parameters[0]
        end

        def name
          @name ||= Application.build_words(parameters[1...parameters.count])
        end

        private

        def create_item
          HTTParty.post(
            item.request_link,
            body: {
              guild_id: item.guild.id,
              key_name: item.gacha_json['key_name'],
              name: name,
              chance: chance
            }
          )
        end
      end
    end
  end
end
