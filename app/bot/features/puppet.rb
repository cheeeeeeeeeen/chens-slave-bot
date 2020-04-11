module Bot
  module Features
    class Puppet < Bot::Features::Base
      def self.options(_); end

      private

      def listen_dm?(event)
        ENV['MASTER_ID'].to_i == event.user.id.to_i
      end
    end
  end
end
