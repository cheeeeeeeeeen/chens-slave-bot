module Bot
  module Features
    class Gacha
      class Delete < Bot::Features::Gacha::Base
        def perform
          destroy_gacha(key_name)
          event.respond("Deleted that worthless scam!")
        end

        private

        def destroy_gacha(key_name)
          HTTParty.delete(
            "#{Application.database_link}/gachas/#{key_name}",
            body: {
              guild_id: guild.id
            }
          )
        end
      end
    end
  end
end
