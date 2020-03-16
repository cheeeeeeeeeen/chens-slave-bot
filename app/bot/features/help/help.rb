module Bot
  module Features
    class Help
      class Help < Bot::Features::Help::Base
        def perform
          event.respond(reply_message)
        end

        private

        def reply_message
          [
            'Seriously?',
            'What are you doing?',
            'Are you that bored?',
            'You need help about asking help? What?',
            'There was once a dragon in a huge tree. ' \
            'That dragon took me away from you because it ' \
            'felt pity for me. It pitied me for having to ' \
            'deal with your peanut brain.'
          ].sample
        end
      end
    end
  end
end
