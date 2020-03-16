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

        def self.description(embed, prefix)
          embed.add_field(
            name: '`remove`  **Remove an Item from a Gacha set**',
            value: 'Delete and remove an item from the specified Gacha set.'
          )
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}item remove <gacha_command> <name>`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}item remove sampleset Chen is Life`\n" \
              'Assume there exists a `sampleset` Gacha set and an Item ' \
              'called "Chen is Life" is in the same set. "Chen is Life" ' \
              "will be removed from the Gacha set.\n"
          }
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
