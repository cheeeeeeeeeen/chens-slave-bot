module Bot
  module Features
    class Gacha
      class All < Bot::Features::Gacha::Base
        attr_reader :gachas_json

        def perform
          fetch_gachas
          event.send_embed do |embed|
            embed.description = all_gachas
          end
        end

        def all_gachas
          data = ''
          gachas_json.each do |gch|
            data += "\n**#{gch['name']}** (#{gch['key_name']})"
          end
          data[0] = ''
          data = '*No Gachas yet.*' if data == ''
          data
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha all`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`all`  **Display All Gachas**',
            value: "Displays all the Gacha sets this server has created.\n" \
              "The format displayed is in:\n`<Gacha Name> (<Gacha Command>)`"
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha all`\nThis will display the " \
              'list of gacha sets this server has.'
          }
        end

        private

        def fetch_gachas
          @gachas_json = HTTParty.get(
            gacha.request_link,
            body: {
              guild_id: gacha.guild.id
            }
          )
          @gachas_json = @gachas_json['gachas']
        end
      end
    end
  end
end
