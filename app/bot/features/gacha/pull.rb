module Bot
  module Features
    class Gacha
      class Pull < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :output_text

        def perform
          retrieve_gacha_and_items
          if gacha_valid?
            prepare_data_and_execute
          else
            event.respond('This Gacha is not yet ready ' \
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
              [[parameters[0].to_i, 20].min, 1].max
            end
          end
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha pull <command> [number]`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`pull`  **Simulate a pull on a Gacha set**',
            value: 'Display the details of the set along with the ' \
              'Item list packed within it.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha pull chen 10`\n" \
              'Perform a simulation of a Gacha pull 10 times. ' \
              'The `number` argument is optional and will default to 1 ' \
              'if none are specified.'
          }
        end

        private

        def retrieve_gacha_and_items
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
          pull_number.times do |_i|
            random = BigDecimal(rand(0...1.0).to_s)
            gacha_set.each do |name, chance|
              next unless random < chance

              pulled_set << name
              @output_text += "\n**#{name}**"
              break
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

        def prepare_data_and_execute
          build_data
          pull_items
          event.send_embed do |embed|
            embed.author = embed_author
            embed.description = output_text
          end
        end
      end
    end
  end
end
