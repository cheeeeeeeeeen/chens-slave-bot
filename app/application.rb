require 'dotenv/load'

module Application
  module_function

  def environment
    ENV['APP_ENVIRONMENT'] || 'development'
  end

  def production?
    environment == 'production'
  end

  def test?
    environment == 'test'
  end

  def development?
    environment == 'development'
  end

  def discord_api_version
    ENV['DISCORD_API_VERSION']
  end

  def api_link
    "https://discordapp.com/api/v#{discord_api_version}"
  end

  def database_link
    'http://localhost:3000/api/v1'
  end

  def feature_class(feature_name)
    require_relative "bot/features/#{file_name(feature_name)}"
    Object.const_get("Bot::Features::#{feature_name}")
  end

  def file_name(class_name)
    class_name.gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_').downcase
  end
end

Bundler.require(:default, Application.environment)
require_relative 'bot/assembler'
