# frozen_string_literal: true

# services/strategies/strategies_registry.rb
require_relative 'loyalty_strategy'
require_relative 'modifier_strategy'

module StrategiesRegistry
  LOYALTY = {
    'Bronze' => LoyaltyStrategy,
    'Silver' => LoyaltyStrategy,
    'Gold' => LoyaltyStrategy
  }.freeze

  MODIFIER = {
    'discount' => ModifierStrategy,
    'increased_cashback' => ModifierStrategy
  }.freeze
end
