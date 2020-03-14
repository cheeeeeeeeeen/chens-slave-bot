module Bot
  module Features
    class Gacha
      class Create < Bot::Features::Gacha::Base
        def perform
          create_gacha
          event.send_embed do |embed|
            embed.description = "Successfully created Gacha for #{guild.name}!"
          end
        end

        def name
          @name ||= Application.build_words(arguments[1...arguments.count])
        end

        private

        def create_gacha
          HTTParty.post(
            gacha.request_link,
            body: {
              guild_id: guild.id,
              key_name: key_name,
              name: name
            }
          )
        end
      end
    end
  end
end
