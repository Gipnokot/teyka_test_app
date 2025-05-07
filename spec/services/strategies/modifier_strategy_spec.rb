# frozen_string_literal: true

# spec/services/strategies/modifier_strategy_spec.rb
require 'spec_helper'
require_relative '../../../services/strategies/modifier_strategy'

RSpec.describe ModifierStrategy, '#initialize' do
  subject(:strategy) { described_class.new(product) }

  context "when product.type is 'discount'" do
    let(:product) { instance_double('Product', type: 'discount', value: '15') }

    it 'uses product.value for percent_discount' do
      expect(strategy.percent_discount).to eq(15.0)
    end

    it 'leaves percent_cashback at zero' do
      expect(strategy.percent_cashback).to eq(0.0)
    end
  end

  context "when product.type is 'increased_cashback'" do
    let(:product) { instance_double('Product', type: 'increased_cashback', value: '8') }

    it 'uses product.value for percent_discount' do
      # В логике текущей стратегии value идёт в discount, не в cashback
      expect(strategy.percent_discount).to eq(8.0)
    end

    it 'leaves percent_cashback at zero' do
      expect(strategy.percent_cashback).to eq(0.0)
    end
  end

  context 'when product.type is neither discount nor increased_cashback' do
    let(:product) { instance_double('Product', type: 'noloyalty', value: nil) }

    it 'sets percent_discount to zero' do
      expect(strategy.percent_discount).to eq(0.0)
    end

    it 'sets percent_cashback to zero' do
      expect(strategy.percent_cashback).to eq(0.0)
    end
  end

  context 'when product is nil' do
    let(:product) { nil }

    it 'treats as noloyalty' do
      expect(strategy.percent_discount).to eq(0.0)
      expect(strategy.percent_cashback).to eq(0.0)
    end
  end
end
