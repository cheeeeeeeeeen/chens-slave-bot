module Bot
  module Features
    class Gacha
      class Pull < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :output_text

        def perform
          get_gacha_and_items
          if gacha_valid?
            build_data
            pull_items
            event.send_embed do |embed|
              embed.author = embed_author
              embed.description = output_text
            end
          else
            event.respond('This Gacha is not yet ready' \
                          'for your greedy needs.')
          end
        end

        def gacha_set
          @gacha_set ||= {}
        end

        def pulled_set
          @pulled_set ||= []
        end

        def pull_number
          @pull_number ||= begin
            if parameters.nil? || parameters.empty?
              1
            else
              [[parameters[0].to_i, 10].min, 1].max
            end
          end
        end

        private

        def get_gacha_and_items
          @gacha_json = HTTParty.get(
            "#{gacha.request_link}/#{gacha.key_name}",
            body: {
              guild_id: gacha.guild.id
            }
          )
          @items_json = @gacha_json['items']
          @gacha_json = @gacha_json['gacha']
        end

        def gacha_valid?
          @gacha_valid ||= begin
            total = BigDecimal('0')
            items_json.each do |item|
              total += BigDecimal(item['chance'])
            end
            total == BigDecimal('100.0')
          end
        end

        def build_data
          @output_text = ''
          counter = BigDecimal('0')
          @items_json.each do |item_data|
            counter += BigDecimal(item_data['chance']) * BigDecimal('0.01')
            gacha_set.merge!(item_data['name'] => counter)
          end
        end

        def pull_items
          pull_number.times do |i|
            random = BigDecimal(rand(0...1.0).to_s)
            gacha_set.each do |name, chance|
              if random < chance
                pulled_set << name
                @output_text += "\n**#{name}**"
                break
              end
            end
          end
          @output_text[0] = ''
        end

        def embed_author
          Discordrb::Webhooks::EmbedAuthor.new(
            name: "#{event.user.username}##{event.user.discord_tag}",
            icon_url: event.user.avatar_url
          )
        end
      end
    end
  end
end
