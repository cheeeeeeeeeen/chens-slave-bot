module Bot
  module Features
    class Gacha
      class Delete < Bot::Features::Gacha::Base
        def perform
          destroy_gacha
          event.respond('Deleted that worthless scam!')
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha delete <command>`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`delete`  **Delete a Gacha set**',
            value: "Delete an existing Gacha set in this server.\n" \
              'Deleted data from this method cannot be recovered.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha delete chen`\n" \
              'This will the Gacha set with the command ' \
              "of `chen`.\n" \
              '\_\_\_\_\_\_\_\_\_\_\_\_'
          }
        end

        private

        def destroy_gacha
          HTTParty.delete(
            "#{gacha.request_link}/#{gacha.key_name}",
            body: {
              guild_id: gacha.guild.id
            }
          )
        end
      end
    end
  end
end
