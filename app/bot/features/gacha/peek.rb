module Bot
  module Features
    class Gacha
      class Peek < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :gacha_verdict,
                    :total_chance, :all_items_string

        def initialize(gacha, event, parameters)
          super(gacha, event, parameters)
          @total_chance = BigDecimal('0')
          @all_items_string = ['']
        end

        def perform
          if show_gacha
            build_output
            gacha_readiness
            display_details
            display_items
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
            "#{gacha.request_link}/show",
            body: {
              guild_id: gacha.guild.id,
              key_name: gacha.key_name
            }
          )
          @items_json = @gacha_json['items']
          @gacha_json = @gacha_json['gacha']
          !@gacha_json.nil?
        end

        def latest_index
          all_items_string.count - 1
        end

        def build_output
          items_json.each do |item|
            str_to_add = "\n#{item['chance'].to_f}% - #{item['name']}"
            add_string_node(str_to_add)
            all_items_string[latest_index] += str_to_add
            @total_chance += BigDecimal(item['chance'])
          end
        end

        def compute_length(added_string)
          (all_items_string[latest_index] + added_string).length > 2000
        end

        def gacha_readiness
          all_items_string[0] = '*No items yet.*' if all_items_string[0].empty?
          @gacha_verdict = "#{total_chance.to_f}% - "
          @gacha_verdict +=
            if total_chance == BigDecimal('100.0')
              'Ready'
            else
              'Not yet ready'
            end
        end

        def display_details
          event.send_embed do |embed|
            embed.add_field(name: '**Gacha Name**', value: gacha_json['name'])
            embed.add_field(name: '**Gacha Command**',
                            value: gacha_json['key_name'])
            embed.add_field(name: '**Items**', value: gacha_verdict)
          end
        end

        def display_items
          all_items_string.each do |item_string|
            event.send_embed do |embed|
              embed.description = item_string
            end
          end
        end

        def add_string_node(str)
          return unless compute_length(str)

          all_items_string[latest_index][0] = ''
          all_items_string << ''
        end
      end
    end
  end
end
