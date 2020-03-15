module Bot
  module Features
    class Gacha
      class Create < Bot::Features::Gacha::Base
        def perform
          create_gacha
          event.send_embed do |embed|
            embed.description =
              "Successfully created Gacha for #{gacha.guild.name}!"
          end
        end

        def name
          @name ||= Application.build_words(parameters)
        end

        def self.description(embed, prefix)
          embed.add_field(
            name: '**Create a Gacha set**  `create`',
            value: "Define and make a new Gacha set in this server.\n" \
              'A Gacha set has a name and a command. The command will be ' \
              'used for identifying the set for other modules and actions.'
          )
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}gacha create <command> <name>`"
          )
          embed.add_field(
            name: 'Example',
            value: "`#{prefix}gacha create chen Chen is Love`\n" \
              'This will create a "Chen is Love" Gacha set with a command ' \
              'of `chen`.'
          )
        end

        private

        def create_gacha
          HTTParty.post(
            gacha.request_link,
            body: {
              guild_id: gacha.guild.id,
              key_name: gacha.key_name,
              name: name
            }
          )
        end
      end
    end
  end
end
