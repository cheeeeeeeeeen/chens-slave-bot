require_relative 'application'

assembler = Bot::Assembler.new
assembler.create_bot
puts "Invite Link: #{assembler.bot.invite_url}"

assembler.install('Help')
assembler.install('Ping')
assembler.install('Prefix')
assembler.install('Gacha')
assembler.install('Item')
assembler.install('Permission')

assembler.deploy
