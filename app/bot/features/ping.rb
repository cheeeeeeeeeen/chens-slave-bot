module Bot
  module Features
    class Ping < Bot::Features::Base
      private

      def action
        @bot.command :ping do |event, n|
          event.respond(process_reply(n))
        rescue Discordrb::Errors::MessageTooLong
          event.respond('Bruh. I can\'t type that long.')
        end
      end

      def process_reply(num)
        if num.to_i <= 1
          'Pong!'
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
