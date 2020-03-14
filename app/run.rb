require_relative 'application'

assembler = Bot::Assembler.new
assembler.create_bot

assembler.install('Ping')
# assembler.install('Prefix')
assembler.install('Gacha')
assembler.install('Item')

assembler.deploy
