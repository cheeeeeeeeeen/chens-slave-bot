module Bot
  module Features
    class Gacha
      class Peek < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :gacha_verdict, :all_items_string

        def perform
          if show_gacha
            build_output
            display_output
          else
            event.respond('There is no such Gacha set found in my brain.')
          end
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha peek <command>`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`peek`  **Look at the contents of a Gacha set**',
            value: 'Display the details of the set along with the ' \
              'Item list packed within it.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha peek chen`\n" \
              'This will display the details of the gacha set with ' \
              "the command `chen` together with the Items.\n" \
              '\_\_\_\_\_\_\_\_\_\_\_\_'
          }
        end

        private

        def show_gacha
          @gacha_json = HTTParty.get(
            "#{gacha.request_link}/#{gacha.key_name}",
            body: {
              guild_id: gacha.guild.id
            }
          )
          @items_json = @gacha_json['items']
          @gacha_json = @gacha_json['gacha']
          !@gacha_json.nil?
        end

        def build_output
          output = ''
          total = BigDecimal('0')
          items_json.each do |item|
            output += "\n#{item['name']} - #{BigDecimal(item['chance']).to_f}%"
            total += BigDecimal(item['chance'])
          end
          output[0] = ''
          @all_items_string = output
          @all_items_string = '*No items yet.*' if @all_items_string == ''
          gacha_readiness(total)
        end

        def gacha_readiness(total)
          @gacha_verdict = "#{total.to_f}% - "
          @gacha_verdict +=
            if total == BigDecimal('100.0')
              'Ready'
            else
              'Not yet ready'
            end
        end

        def display_output
          event.send_embed do |embed|
            embed.add_field(name: '**Gacha Name**', value: gacha_json['name'])
            embed.add_field(name: '**Gacha Command**',
                            value: gacha_json['key_name'])
            embed.add_field(name: "**Items** (#{gacha_verdict})",
                            value: all_items_string)
          end
        end
      end
    end
  end
end
