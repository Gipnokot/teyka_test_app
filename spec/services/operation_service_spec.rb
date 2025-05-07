# spec/services/operation_service_spec.rb
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../services/operation_service'

RSpec.describe OperationService, type: :service do
  let(:user)     { create(:user, template: create(:template)) }
  let(:product)  { create(:product) }
  let(:positions) do
    [
      { id: product.id, price: 100.0, quantity: 2 },
      { id: product.id, price: 50.0,  quantity: 1 }
    ]
  end
  let(:operation_service) { described_class.new(user.id, positions) }

  describe '#calculate' do
    it 'calculates total values correctly' do
      # Первый калькулятор: raw_sum = 150, value = 200, discount = 15, cashback = 7
      mock1 = double('PositionCalculator')
      allow(mock1).to receive(:raw_sum).and_return(150.0)
      allow(mock1).to receive(:result).and_return(
        id: product.id,
        type: product.type,
        value: 200.0,
        discount_percent: 15,
        discount_value: 15.0,
        cashback_percent: 7,
        cashback_value: 7.0
      )

      # Второй калькулятор: raw_sum = 50, value = 105, discount = 5, cashback = 14
      mock2 = double('PositionCalculator')
      allow(mock2).to receive(:raw_sum).and_return(50.0)
      allow(mock2).to receive(:result).and_return(
        id: product.id,
        type: product.type,
        value: 105.0,
        discount_percent: 10,
        discount_value: 5.0,
        cashback_percent: 14,
        cashback_value: 14.0
      )

      # Первый вызов PositionCalculator.new → mock1, второй → mock2
      allow(PositionCalculator).to receive(:new).and_return(mock1, mock2)

      result = operation_service.calculate

      expect(result[:status]).to eq('success')
      expect(result[:total_price]).to eq(285.0) # 305.0 – 20.0
      expect(result[:bonus_info][:available_to_spend]).to eq(200.0) # 150 + 50
      expect(result[:bonus_info][:cashback_earned]).to eq(21.0)     # 7 + 14
      expect(result[:discount_info][:total_discount]).to eq(20.0)   # 15 + 5
    end

    it 'raises an error if the user is not found' do
      expect { described_class.new(999, positions) }.to raise_error('User 999 not found')
    end

    it 'raises an error if a product is not found' do
      invalid_positions = [{ id: -1, price: 100.0, quantity: 2 }]
      allow(PositionCalculator).to receive(:new).and_raise('Product with ID -1 not found')

      expect { described_class.new(user.id, invalid_positions).calculate }
        .to raise_error('Product with ID -1 not found')
    end

    it 'calculates bonus information correctly' do
      # Повторяем моки из первого теста
      allow(PositionCalculator).to receive(:new)
        .and_return(
          double('PositionCalculator', raw_sum: 150.0, result: {
                   id: product.id,
                   type: product.type,
                   value: 200.0,
                   discount_percent: 15,
                   discount_value: 15.0,
                   cashback_percent: 7,
                   cashback_value: 7.0
                 }),
          double('PositionCalculator', raw_sum: 50.0, result: {
                   id: product.id,
                   type: product.type,
                   value: 105.0,
                   discount_percent: 10,
                   discount_value: 5.0,
                   cashback_percent: 14,
                   cashback_value: 14.0
                 })
        )

      result = operation_service.calculate

      expect(result[:bonus_info][:balance]).to eq(user.bonus)
      expect(result[:bonus_info][:available_to_spend]).to eq(200.0)
      expect(result[:bonus_info][:cashback_earned]).to eq(21.0)
    end
  end
end
