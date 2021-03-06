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
            embed.title = "`#{prefix}`  General Module Commands"
            commands_display(embed)
            embed.footer = { text: versions }
          end
        end

        def versions
          "Bot #{Application.version} : Server #{assembler.server_version}"
        end

        def prefix
          @prefix ||= assembler.fetch_prefix(guild.id.to_s)
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
              name: "`#{feature_name.downcase}`  **#{feature_name}**",
              value: Application.feature_class(feature_name)
                                .options(prefix)[:description]
            )
          end
        end

        def permission_display(embed, action = nil, add_hr = false)
          embed.add_field(
            name: '*Permissions*',
            value: "*#{get_permissions(action)}*#{horizontal_rule if add_hr}"
          )
        end

        def horizontal_rule
          "\n" + '\_\_\_\_\_\_\_\_\_\_\_\_'
        end

        def reply_message
          [
            'Need help? I got your back.', 'What is your feeble request?',
            'Displaying the module commands I can run...',
            "I'm here.", 'Teri~ Teri~', 'Slave of Chen, at your service.',
            'Fear not, my friend, for I am here to help.',
            'Do not worry. We were all idiots at one point.',
            '大丈夫ですか。', 'Have I seen you somewhere before?'
          ].sample
        end

        def require_files
          require_relative "../#{command}/base"
          Dir["./app/bot/features/#{command}/*.rb"].each do |f|
            action_name = f.split('/').last.split('.').first
            if action_name != 'base'
              require_relative "../#{command}/#{action_name}"
              action_list << action_name
            end
          end
        end

        def get_permissions(action = nil)
          response = HTTParty.get(
            "#{Application.database_link}/permissions/show",
            body: { guild_id: guild.id, action_name: action,
                    feature_name: command }
          )
          response = response['key_names']&.gsub(',', ', ')
          response = 'None' if response.nil? || response.empty?
          response
        end
      end
    end
  end
end
