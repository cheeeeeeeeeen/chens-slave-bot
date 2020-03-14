module Bot
  module Features
    class Gacha
      class Delete < Bot::Features::Gacha::Base
        def perform
          destroy_gacha
          event.respond('Deleted that worthless scam!')
        end

        private

        def destroy_gacha
          HTTParty.delete(
            "#{gacha.request_link}/#{gacha.key_name}",
            body: {
              guild_id: gacha.guild.id
            }
          )
        end
      end
    end
  end
end
