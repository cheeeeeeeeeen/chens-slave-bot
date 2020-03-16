module Bot
  module Features
    class Ping < Bot::Features::Base
      def self.options(_)
        {
          description: 'A command for testing if the bot is ' \
            "responding to the server.\n" \
            'It is also a valuable tool for my mistress to develop me.'
        }
      end

      private

      def feature(event, num, _)
        event.respond(process_reply(num))
      end

      def process_reply(num)
        if num.to_i <= 1
          'Pong!'
        elsif num.to_i >= 100
          "Bruh. I can't type that long."
        else
          multi_pong(num)
        end
      end

      def multi_pong(num)
        str = ''
        num.to_i.times do |i|
          str += "\nPong #{i}!"
        end
        str[0] = ''
        str
      end
    end
  end
end
