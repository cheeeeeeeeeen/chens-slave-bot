require_relative 'application'

assembler = Bot::Assembler.new
assembler.create_bot

assembler.install('Ping')
assembler.install('ModifyPrefix')

assembler.deploy
