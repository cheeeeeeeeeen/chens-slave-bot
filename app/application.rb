require 'dotenv/load'

module Application
  module_function

  def version
    '1.3.1.0'
  end

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
    ENV['DATABASE_LINK'] || 'http://localhost:3000/api/v1'
  end

  def feature_class(feature_name)
    require_relative "bot/features/#{file_name(feature_name)}"
    Object.const_get("Bot::Features::#{feature_name}")
  end

  def action_class(feature, action)
    require_relative "#{file_name(feature)}/#{file_name(action)}"
    Object.const_get("#{feature}::#{action.capitalize}")
  end

  def incident_class(incident_name)
    require_relative "bot/incidents/#{file_name(incident_name)}"
    Object.const_get("Bot::Incidents::#{incident_name}")
  end

  def file_name(class_name)
    class_name.gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_').downcase
  end

  def build_words(words_array)
    words_array.join(' ')
  end
end

Bundler.require(:default, Application.environment)
require_relative 'bot/assembler'
