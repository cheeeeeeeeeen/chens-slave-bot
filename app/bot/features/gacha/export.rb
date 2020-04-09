module Bot
  module Features
    class Gacha
      class Export < Bot::Features::Gacha::Base
        attr_reader :gacha_json, :items_json, :string_io,
                    :export_file

        def perform
          event.respond('Exporting. Please wait...')
          fetch_data
          assemble_string
          write_to_file_and_open
          send_gacha_set
          clean_files
        end

        def base_temp_path
          './export'
        end

        def file_path
          @file_path ||= "#{base_temp_path}/#{event.message.id}"
        end

        def file_name
          "#{file_path}/#{gacha_json['key_name']}.txt"
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha export <command>`"
          )
          embed.add_field(description_example(prefix))
        end

        def self.description_header
          {
            name: '`export`  **Export a Gacha set**',
            value: 'Export a Gacha set from this server to a ' \
              'message attachment.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha export sample_gacha_set`\n" \
              'Given there exists a Gacha set with a command name of ' \
              '`sample_gacha_set`, the bot will send a file with the ' \
              'appropriate details and Items.'
          }
        end

        private

        def fetch_data
          @gacha_json = HTTParty.get(
            "#{gacha.request_link}/show",
            body: {
              guild_id: gacha.guild.id,
              key_name: gacha.key_name
            }
          )
          @items_json = @gacha_json['items']
          @gacha_json = @gacha_json['gacha']
        end

        def assemble_string
          @string_io = gacha_json['key_name'] + "\n" + gacha_json['name']
          items_json.each do |item|
            @string_io += "\n" + item['chance'] + ' ' + item['name']
          end
        end

        def write_to_file_and_open
          FileUtils.mkdir_p(file_path)
          File.write(file_name, string_io, mode: 'w')
          @export_file = File.open(file_name, 'r')
        end

        def send_gacha_set
          event.send_file(export_file, caption: 'Here it is!')
        end

        def clean_files
          export_file.close
          FileUtils.rm_rf(base_temp_path)
        end
      end
    end
  end
end
