module Bot
  module Features
    class Item
      class Base
        attr_reader :item, :event, :parameters

        def initialize(item, event, parameters)
          @item = item
          @event = event
          @parameters = parameters
        end

        def perform
          event.respond('This action in the Item module is not yet supported.')
        end

        def self.description(_, _); end
      end
    end
  end
end
