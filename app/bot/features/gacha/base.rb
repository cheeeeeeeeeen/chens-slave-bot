module Bot
  module Features
    class Gacha
      class Base
        attr_reader :gacha, :event, :parameters

        def initialize(gacha, event, parameters)
          @gacha = gacha
          @event = event
          @parameters = parameters
        end

        def perform
          event.respond('This action in the Gacha module is not yet supported.')
        end
      end
    end
  end
end
