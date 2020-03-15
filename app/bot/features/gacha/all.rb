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
          embed.add_field(
            name: '**Display All Gachas**  `all`',
            value: "Displays all the Gacha sets this server has created.\n" \
              "The format displayed is in:\n`<Gacha Name> (<Gacha Command>)`"
          )
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha all`"
          )
          embed.add_field(
            name: 'Example',
            value: "`#{prefix}gacha all`\nI will return the " \
              "list of gacha sets this server has.\n" \
              '\_\_\_\_\_\_\_\_\_\_\_\_'
          )
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
