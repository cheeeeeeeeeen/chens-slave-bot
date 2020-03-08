require_relative 'application'

api_link = "https://discordapp.com/api/v#{ENV['DISCORD_API_VERSION']}"
bot = Discordrb::Bot.new token: ENV['SECRET_BOT_TOKEN']

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.message(content: 'guild') do |event|
  response = HTTParty.get(
    "#{api_link}/guilds/601620022632120370",
    headers: {
      'Authorization' => "Bot #{ENV['SECRET_BOT_TOKEN']}"
    }
  )
  event.respond "```#{response['name']}```"
end

bot.run
