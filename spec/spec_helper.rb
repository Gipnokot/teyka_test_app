# frozen_string_literal: true

# spec/spec_helper.rb
require_relative '../config/db_connection'
require 'factory_bot'

# подключение моделей
Dir[File.join(__dir__, '../models', '*.rb')].each { |file| require file }

# подключение фактории
FactoryBot.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryBot.find_definitions

FactoryBot.define do
  to_create(&:save)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # загружаем schema.sql перед запуском тестов, если таблиц ещё нет
  config.before(:suite) do
    DB.run('PRAGMA foreign_keys = ON;')

    unless DB.table_exists?(:users) && DB.table_exists?(:templates)
      puts '[setup] Применяю schema.sql...'
      schema = File.read(File.expand_path('../db/schema.sql', __dir__))
      DB.run(schema)
    end
  end

  # чистим таблицы после каждого теста
  config.after do
    %i[operations products users templates].each do |table|
      DB.from(table).truncate if DB.table_exists?(table)
    end
  end

  # подключаем FactoryBot
  config.include FactoryBot::Syntax::Methods
end
