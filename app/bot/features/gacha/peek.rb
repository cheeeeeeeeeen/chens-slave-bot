module Bot
  module Features
    class Gacha
      class Peek < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :gacha_verdict, :all_items_string

        def perform
          show_gacha
          build_output
          event.send_embed do |embed|
            embed.add_field(name: '**Gacha Name**', value: gacha_json['name'])
            embed.add_field(name: '**Gacha Command**',
                            value: gacha_json['key_name'])
            embed.add_field(name: "**Items** (#{gacha_verdict})",
                            value: all_items_string)
          end
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
      end
    end
  end
end