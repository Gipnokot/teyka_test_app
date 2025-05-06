# frozen_string_literal: true

# db_connection.rb

require 'sequel'

# непосредственно подключение к БД
DB = Sequel.sqlite('./db/test.db')
