# frozen_string_literal: true

require 'sequel'
require 'fileutils'

# Определим путь к базе данных в зависимости от окружения
db_file = if ENV['RACK_ENV'] == 'test'
            './db/test_spec.db' # бд для тестов
          else
            './db/test.db'      # основная БД
          end

begin
  DB = Sequel.sqlite(db_file)
  DB.run('PRAGMA foreign_keys = ON;')
  puts "Подключение к базе данных: #{db_file}"
rescue Sequel::DatabaseConnectionError => e
  puts "Ошибка подключения к базе данных: #{e.message}"
  exit(1)
end

# соединение по умолчанию для всех моделей
Sequel::Model.db = DB
