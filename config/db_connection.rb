# frozen_string_literal: true

require 'sequel'
require 'fileutils'

# Определим путь к базе данных в зависимости от окружения
db_file = if ENV['RACK_ENV'] == 'test'
            './db/test_spec.db' # бд для тестов
          else
            './db/test.db'      # основная БД
          end

# Проверка существования директории
FileUtils.mkdir_p(File.dirname(db_file)) unless File.exist?(File.dirname(db_file))

begin
  DB = Sequel.sqlite(db_file)
  puts "Подключение к базе данных: #{db_file}"
rescue Sequel::DatabaseConnectionError => e
  puts "Ошибка подключения к базе данных: #{e.message}"
  exit(1)
end

# соединение по умолчанию для всех моделей
Sequel::Model.db = DB
