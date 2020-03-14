module Bot
  module Features
    class Item
      class Remove < Bot::Features::Item::Base
        def perform
          destroy_item
          event.respond("Removed the item from #{item.gacha_json['name']}.")
        end

        def name
          @name ||= Application.build_words(parameters[0...parameters.count])
        end

        private

        def destroy_item
          HTTParty.delete(
            item.request_link,
            body: {
              guild_id: item.guild.id,
              key_name: item.gacha_json['key_name'],
              name: name
            }
          )
        end
      end
    end
  end
end
