require_relative 'application'

assembler = Bot::Assembler.new
assembler.create_bot
puts "Invite Link: #{assembler.bot.invite_url}"

assembler.install('Gacha')
assembler.install('Help')
assembler.install('Invite')
assembler.install('Item')
assembler.install('Permission')
assembler.install('Ping')
assembler.install('Prefix')

assembler.deploy
