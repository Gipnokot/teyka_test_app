# frozen_string_literal: true

# config.ru
require 'bundler/setup'
Bundler.require(:default)

# Загружаем конфигурацию БД перед приложением
require_relative './config/db_connection'

# Загружаем основное приложение
require_relative './app'

# Настраиваем приложение
configure do
  # Включаем логгирование SQL-запросов в development
  DB.loggers << Logger.new($stdout) if development?
end

# Запускаем приложение
run Sinatra::Application
