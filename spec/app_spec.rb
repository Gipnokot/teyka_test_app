# spec/app_spec.rb
require 'spec_helper'
require 'rack/test'
require_relative '../app'

describe 'Teyka test app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Helper to reset DB and seed minimal data
  def seed_operation_data
    # Clear tables
    DB[:operations].delete
    DB[:users].delete
    DB[:products].delete
    DB[:templates].delete

    # Insert template and user
    DB[:templates].insert(id: 1, name: 'Bronze', discount: 70, cashback: 10)
    DB[:users].insert(id: 1, name: 'Тест', template_id: 1, bonus: 10_000)

    # Insert products (no price column in schema)
    DB[:products].insert(id: 2, name: 'Товар 1')
    DB[:products].insert(id: 3, name: 'Товар 2')
    DB[:products].insert(id: 4, name: 'Товар 3')
  end

  describe 'POST /operation' do
    let(:valid_data) do
      {
        user_id: 1,
        positions: [
          { id: 2, price: 50,  quantity: 2 },
          { id: 3, price: 40,  quantity: 1 },
          { id: 4, price: 150, quantity: 2 }
        ]
      }
    end

    before do
      seed_operation_data
    end

    it 'returns status 200 for successful operation calculation' do
      header 'CONTENT_TYPE', 'application/json'
      post '/operation', valid_data.to_json

      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json['status']).to eq('success')
      expect(json['operation_id']).to be_a(Integer)
    end

    it 'returns status 422 for invalid operation data' do
      seed_operation_data
      header 'CONTENT_TYPE', 'application/json'
      post '/operation', { user_id: nil, positions: [] }.to_json

      expect(last_response.status).to eq(422)
      json = JSON.parse(last_response.body)
      expect(json['status']).to eq('error')
    end
  end

  describe 'POST /submit' do
    let(:valid_confirmation_data) do
      {
        operation_id: 2,
        write_off: 140.0
      }
    end

    before do
      # seed user and template
      DB[:operations].delete
      DB[:users].delete
      DB[:templates].delete

      DB[:templates].insert(id: 1, name: 'Bronze', discount: 70, cashback: 10)
      DB[:users].insert(id: 1, name: 'Тест', template_id: 1, bonus: 10_000)

      # seed an existing operation
      DB[:operations].insert(
        id: 2,
        user_id: 1,
        cashback: 20.0,
        cashback_percent: 10.0,
        discount: 140.0,
        discount_percent: 70.0,
        write_off: 0,
        check_summ: 200.0,
        done: false,
        allowed_write_off: 150.0
      )
    end

    it 'returns status 200 for successful operation confirmation' do
      header 'CONTENT_TYPE', 'application/json'
      post '/submit', valid_confirmation_data.to_json

      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json['status']).to eq('confirmed')
      expect(json['operation_id']).to eq(2)
    end

    it 'returns status 422 for invalid confirmation data' do
      header 'CONTENT_TYPE', 'application/json'
      post '/submit', { operation_id: nil, write_off: nil }.to_json

      expect(last_response.status).to eq(422)
      json = JSON.parse(last_response.body)
      expect(json['status']).to eq('error')
    end
  end
end
