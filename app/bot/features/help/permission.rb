module Bot
  module Features
    class Help
      class Permission < Bot::Features::Help::Base
        def perform
          event.send_embed(
            "Limiting my modules and commands because#{reply_message}"
          ) do |embed|
            embed.title = "`#{prefix}permission`  Permission Module"
            description(embed)
            permission_keys_display(embed)
            usage_details(embed)
            example_details(embed)
          end
        end

        private

        def permission_keys_display(embed)
          all_keys = Discordrb::Permissions::Flags.map { |_, v| v }.join(', ')
          embed.add_field(
            name: 'Permission Keys',
            value: all_keys
          )
          embed.add_field(
            name: 'Special Keys',
            value: 'remove_all - Removes all permissions from the command.' \
          )
        end

        def description(embed)
          embed.description = 'This is used for setting permissions ' \
            'for other modules, limiting that module to be accessible to ' \
            "users with the specified permissions.\n**The `permission` " \
            "module is not for setting user or role permissions.**\n" \
            'One can assign multiple permission settings within a ' \
            "module.\nThe `permission` module is only limited to roles " \
            'with an `administrator` permission and cannot be changed. ' \
            'The `help` and `invite` modules also cannot have permission ' \
            "settings.\n**__The permissions only apply to roles. Channel " \
            'overwrites are not yet supported.__**'
        end

        def usage_details(embed)
          embed.add_field(
            name: 'Usage',
            value: "`#{prefix}permission <module> [action] <keys*>`"
          )
        end

        def example_details(embed)
          embed.add_field(
            name: 'Example',
            value: "`#{prefix}permission gacha create view_audit_log " \
              "attach_files`\nThis command will limit `gacha create` " \
              'to only be usable by users who has a role that can view ' \
              "audit logs and attach files in their messages.\n" \
              'The `action` argument is optional, but is required for ' \
              "modules with actions.\nThe `keys` argument are values " \
              'listed in Permission Keys used to specify a permission.'
          )
        end

        def reply_message
          [
            ' people are butts? Sign me up.',
            ' there are too many abusive morons? Go.',
            ' annoying potatoes keep creating unwanted sets? R.I.P.',
            ' crying hoes cheat in my system instead? Nice.',
            " I'm pretty? Oh gosh... I already knew that.",
            ' some loser keeps moaning? Let them cry more.',
            '... wait. Are you crying?',
            '... what... You forgot? Get out.'
          ].sample
        end
      end
    end
  end
end
