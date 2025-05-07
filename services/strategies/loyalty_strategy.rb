# frozen_string_literal: true

# services/strategies/loyalty_strategy.rb
class LoyaltyStrategy
  attr_reader :percent_discount, :percent_cashback

  def initialize(template)
    @percent_discount = template.discount.to_f
    @percent_cashback = template.cashback.to_f
  end
end
