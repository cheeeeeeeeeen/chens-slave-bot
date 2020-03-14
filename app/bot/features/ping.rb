module Bot
  module Features
    class Ping < Bot::Features::Base
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
