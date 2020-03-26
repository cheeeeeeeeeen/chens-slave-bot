module Bot
  module Features
    class Invite < Bot::Features::Base
      def self.options(_)
        {
          description: "A command for displaying the bot's " \
            "invitation link. That's it."
        }
      end

      private

      def feature(event, _, _)
        event.respond(
          "Let's have some fun in the other servers, eh?\n" \
          "#{bot.invite_url}"
        )
      end
    end
  end
end
