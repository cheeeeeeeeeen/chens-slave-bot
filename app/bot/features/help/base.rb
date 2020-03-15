module Bot
  module Features
    class Help
      class Base
        attr_reader :event, :arguments, :assembler, :command

        def initialize(event, command, arguments, assembler)
          @event = event
          @command = command
          @arguments = arguments
          @assembler = assembler
        end

        def perform
          event.send_embed(
            reply_message
          ) do |embed|
            embed.title = "General Module Commands  `#{prefix}`"
            commands_display(embed)
          end
        end

        def prefix
          @prefix ||= assembler.prefix_data[guild.id.to_s]
        end

        def guild
          @guild ||= event.server
        end

        def action_list
          @action_list ||= []
        end

        private

        def commands_display(embed)
          assembler.feature_list.sort.each do |feature_name|
            embed.add_field(
              name: "**#{feature_name}**  `#{feature_name.downcase}`",
              value: Application.feature_class(feature_name)
                                .options[:description]
            )
          end
        end

        def reply_message
          [
            'Need help? I got your back.',
            'Displaying the module commands I can run...',
            "I'm here.",
            'Teri~ Teri~',
            'Fear not, my friend, for I am here to help.',
            'Slave of Chen, at your service.',
            'What is your feeble request?',
            'Do not worry. We were all idiots at one point.'
          ].sample
        end

        def require_files
          Dir["./app/bot/features/#{command}/*.rb"].each do |f|
            action_name = f.split('/').last.split('.').first
            require_relative "../#{command}/#{action_name}"
            action_list << action_name unless action_name == 'base'
          end
        end
      end
    end
  end
end
