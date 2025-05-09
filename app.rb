# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'config/db_connection'
require_relative 'models/user'
require_relative 'models/product'
require_relative 'models/template'
require_relative 'models/operation'
require_relative 'services/operation_service'
require_relative 'services/operation_confirmation_service'

before do
  content_type :json
end

# Эндпоинт для расчета операции
post '/operation' do
  request_body = request.body.read
  data = JSON.parse(request_body, symbolize_names: true)

  # Проверка на пустые или неверные данные
  user_id = data[:user_id]
  positions = data[:positions]

  if user_id.to_i <= 0 || positions.nil? || positions.empty?
    status 422
    return { status: 'error', message: 'Invalid operation data' }.to_json
  end

  # Проверка существования пользователя
  unless User.where(id: user_id).count > 0
    status 422
    puts "User with id #{user_id} not found"
    return { status: 'error', message: 'User not found' }.to_json
  end

  # Выполнение расчета
  result = OperationService.new(user_id, positions).calculate
  status 200
  result.to_json
rescue JSON::ParserError
  status 400
  { status: 'error', message: 'Invalid JSON format' }.to_json
rescue StandardError => e
  # Логируем ошибку
  puts "Error during operation calculation: #{e.message}"
  puts e.backtrace.join("\n")
  status 422
  { status: 'error', message: 'Operation calculation failed' }.to_json
end

# Эндпоинт для подтверждения операции
post '/submit' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  operation_id = data[:operation_id]
  write_off = data[:write_off].to_f

  # Проверка на валидность данных
  if operation_id.to_i <= 0 || write_off <= 0
    status 422
    return { status: 'error', message: 'Invalid confirmation data' }.to_json
  end

  # Проверка существования операции
  unless Operation.where(id: operation_id).count > 0
    status 422
    return { status: 'error', message: 'Operation not found' }.to_json
  end

  # Выполнение подтверждения
  result = OperationConfirmationService.new(operation_id, write_off).call
  status 200
  result.to_json
rescue JSON::ParserError
  status 400
  { status: 'error', message: 'Invalid JSON format' }.to_json
rescue StandardError => e
  # Логируем ошибку
  puts "Error during operation confirmation: #{e.message}"
  puts e.backtrace.join("\n")
  status 422
  { status: 'error', message: 'Confirmation failed' }.to_json
end
