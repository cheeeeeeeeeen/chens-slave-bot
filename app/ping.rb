# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'

bot = Discordrb::Bot.new token: ENV['SECRET_BOT_TOKEN']

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

# This method call has to be put at the end of your script,
# it is what makes the bot actually connect to Discord.
# If you leave it out (try it!) the script will simply stop
# and the bot will not appear online.
bot.run
