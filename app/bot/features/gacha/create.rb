module Bot
  module Features
    class Gacha
      class Create < Bot::Features::Gacha::Base
        def perform
          create_gacha
          event.send_embed do |embed|
            embed.description =
              "Successfully created Gacha for #{gacha.guild.name}!"
          end
        end

        def name
          @name ||= Application.build_words(parameters)
        end

        private

        def create_gacha
          HTTParty.post(
            gacha.request_link,
            body: {
              guild_id: gacha.guild.id,
              key_name: gacha.key_name,
              name: name
            }
          )
        end
      end
    end
  end
end
