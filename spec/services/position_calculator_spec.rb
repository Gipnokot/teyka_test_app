# frozen_string_literal: true

# spec/services/position_calculator_spec.rb
require 'spec_helper'
require_relative '../../services/position_calculator'

RSpec.describe PositionCalculator, type: :service do
  let(:product) { double('Product', id: 1, type: product_type) }
  let(:loyalty_strategy) { LoyaltyStrategy.new(double('Template', discount: 10, cashback: 5)) }
  let(:modifier_strategy) { ModifierStrategy.new(double('Product', type: modifier_type, value: modifier_value)) }

  let(:price) { 100.0 }
  let(:quantity) { 2 }

  describe '#result' do
    subject do
      described_class.new(product: product, price: price, quantity: quantity, loyalty_strategy: loyalty_strategy,
                          modifier_strategy: modifier_strategy).result
    end

    context 'when product type is "discount"' do
      let(:product_type) { 'discount' }
      let(:modifier_type) { 'discount' }
      let(:modifier_value) { 20 }

      it 'calculates the raw sum correctly' do
        expect(subject[:value]).to eq(price * quantity)
      end

      it 'calculates discount percent correctly' do
        expect(subject[:discount_percent]).to eq(30)
      end

      it 'calculates cashback percent correctly' do
        expect(subject[:cashback_percent]).to eq(5)
      end

      it 'calculates discount value correctly' do
        expect(subject[:discount_value]).to eq((price * quantity) * 0.30)
      end

      it 'calculates cashback value correctly' do
        expect(subject[:cashback_value]).to eq((price * quantity) * 0.05)
      end
    end

    context 'when product type is "noloyalty"' do
      let(:product_type) { 'noloyalty' }
      let(:modifier_type) { 'discount' }
      let(:modifier_value) { 20 }

      it 'calculates the raw sum correctly' do
        expect(subject[:value]).to eq(price * quantity)
      end

      it 'calculates discount percent correctly (0 from loyalty, modifier applies)' do
        expect(subject[:discount_percent]).to eq(20)
      end

      it 'calculates cashback percent correctly (0 from loyalty)' do
        expect(subject[:cashback_percent]).to eq(0)
      end

      it 'calculates discount value correctly' do
        expect(subject[:discount_value]).to eq((price * quantity) * 0.20)
      end

      it 'calculates cashback value correctly' do
        expect(subject[:cashback_value]).to eq(0.0)
      end
    end

    context 'when there is no modifier' do
      let(:product_type) { 'discount' }
      let(:modifier_type) { 'noloyalty' }
      let(:modifier_value) { 0 }

      it 'calculates discount percent correctly' do
        expect(subject[:discount_percent]).to eq(10)
      end

      it 'calculates cashback percent correctly' do
        expect(subject[:cashback_percent]).to eq(5)
      end
    end
  end
end
