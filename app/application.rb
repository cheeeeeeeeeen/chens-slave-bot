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

  def root
    File.join('..')
  end
end

Bundler.require(:default, Application.environment)
