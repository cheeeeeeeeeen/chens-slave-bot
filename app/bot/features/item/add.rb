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

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}item add <gacha_command> <chance> <name>`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`add`  **Add an Item to a Gacha set**',
            value: "Create an item and add it to the specified Gacha set.\n" \
              "An Item has a name and a chance percentage. The name is \n" \
              'used for identifying the Item.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}item add sampleset 4.71 Chen is Life`\n" \
              'Assume there exists a `sampleset` Gacha set. An Item called ' \
              '"Chen is Life" will be added to `sampleset` with a chance ' \
              "of 4.71% to be pulled.\n" \
              '\_\_\_\_\_\_\_\_\_\_\_\_'
          }
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
