require_relative 'application'

assembler = Bot::Assembler.new
assembler.create_bot

assembler.install('Ping')
assembler.install('ModifyPrefix')
assembler.install('CreateGacha')
assembler.install('ShowGacha')
assembler.install('ListGacha')
assembler.install('DeleteGacha')

assembler.deploy
