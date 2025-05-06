# frozen_string_literal: true

# db_connection.rb

require 'sequel'

# непосредственно подключение к БД
begin
  DB = Sequel.sqlite('./db/test.db')
rescue Sequel::DatabaseConnectionError => e
  puts "Ошибка подключения к базе данных: #{e.message}"
  exit(1)
end

# установка соедниения с БД умолчанию для всех моделей
Sequel::Model.db = DB
