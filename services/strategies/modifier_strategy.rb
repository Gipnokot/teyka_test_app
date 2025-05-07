# frozen_string_literal: true

# services/strategies/modifier_strategy.rb
class ModifierStrategy
  attr_reader :percent_discount, :percent_cashback

  # product - экземпляр модели Product
  def initialize(product)
    @percent_cashback = 0.0

    @percent_discount = case product&.type
                        when 'discount', 'increased_cashback'
                          product.value.to_f
                        else
                          0.0
                        end
  end
end
