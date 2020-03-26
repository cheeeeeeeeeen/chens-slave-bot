module Bot
  module Features
    class Gacha
      class Upload < Bot::Features::Gacha::Base
        attr_reader :response

        def perform
          event.respond('Processing. Please wait...')
          send_file_url
          display_success
        end

        def self.description(embed, prefix)
          embed.add_field(description_header)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha upload`"
          )
          embed.add_field(description_example(prefix))
          embed.add_field(file_format)
        end

        def self.description_header
          {
            name: '`upload`  **Upload a Gacha set through an attachment**',
            value: 'Create a Gacha set in this server by uploading an ' \
              "attachment.\nThis module is able to create a gacha set " \
              'with items contained within the same set.'
          }
        end

        def self.description_example(prefix)
          {
            name: 'Example',
            value: "`#{prefix}gacha upload`\n" \
              'Given an attachment was specified, the bot will fetch the ' \
              'file and read it, then create the Gacha set and Items.'
          }
        end

        def self.file_format
          {
            name: 'File Format',
            value: "```\ngacha_command\nGacha Sample Name\n70 name of item " \
              "with 70% chance to get\n20 Another Item\n5.5 item with a " \
              "decimal percentage\n4.5 3rd line of file is the list of items```"
          }
        end

        private

        def send_file_url
          @reponse = HTTParty.post(
            "#{gacha.request_link}/upload",
            body: {
              guild_id: gacha.guild.id,
              file_urls: event.message.attachments.map(&:url)
            }
          )
        end

        def display_success
          event.respond("**Processing is complete.**\nPlease check the data " \
                        "if they are correct.\nIf the data is malformed or " \
                        'if the set cannot be found, then recheck your file.' \
                        "\nDon't blame me. Give me a break.")
        end
      end
    end
  end
end
