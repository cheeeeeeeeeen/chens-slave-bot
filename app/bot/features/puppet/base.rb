module Bot
  module Features
    class Puppet
      class Base
        attr_reader :event, :parameters, :puppet

        def initialize(puppet, event, parameters)
          @puppet = puppet
          @event = event
          @parameters = parameters
        end

        def perform
          event.respond('This action in the Puppet module ' \
                        'is not yet supported.')
        end

        def self.description(_, _); end
      end
    end
  end
end
