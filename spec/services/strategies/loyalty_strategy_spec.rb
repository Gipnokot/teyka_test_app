# frozen_string_literal: true

# spec/services/strategies/loyalty_strategy_spec.rb
require 'spec_helper'
require_relative '../../../services/strategies/loyalty_strategy'

RSpec.describe LoyaltyStrategy, '#initialize' do
  subject(:strategy) { described_class.new(template) }

  let(:template) { instance_double('Template', discount: 12, cashback: 7) }

  it 'sets percent_discount from template.discount' do
    expect(strategy.percent_discount).to eq(12.0)
  end

  it 'sets percent_cashback from template.cashback' do
    expect(strategy.percent_cashback).to eq(7.0)
  end

  context 'when template has zero values' do
    let(:template) { instance_double('Template', discount: 0, cashback: 0) }

    it 'handles zero discount' do
      expect(strategy.percent_discount).to eq(0.0)
    end

    it 'handles zero cashback' do
      expect(strategy.percent_cashback).to eq(0.0)
    end
  end
end
