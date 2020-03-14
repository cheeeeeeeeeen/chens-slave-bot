module Bot
  module Features
    class Gacha
      class Base
        attr_reader :gacha, :event, :arguments

        def initialize(gacha, event, arguments)
          @gacha = gacha
          @event = event
          @arguments = arguments
        end

        def perform
          event.respond("This action in the Gacha module is not yet supported.")
        end

        private

        def guild
          @guild ||= gacha.guild
        end

        def key_name
          @key_name ||= arguments[0]
        end
      end
    end
  end
end
