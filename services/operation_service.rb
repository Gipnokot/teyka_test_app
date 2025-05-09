# frozen_string_literal: true

# services/operation_service.rb
require_relative 'strategies/loyalty_strategy'
require_relative 'strategies/modifier_strategy'
require_relative 'strategies/strategies_registry'
require_relative 'position_calculator'

class OperationService
  def initialize(user_id, positions)
    @user = User[user_id]
    raise ArgumentError, "User #{user_id} not found" unless @user

    @positions = positions
    @user.template.name.downcase.capitalize
    @loyalty = StrategiesRegistry::LOYALTY
               .fetch(@user.template.name) { raise "Loyalty strategy for #{@user.template.name} not found" }
               .new(@user.template)
  end

  def calculate
    pos_calculators = @positions.map do |pos|
      product = Product[pos[:id]]
      raise "Product with ID #{pos[:id]} not found" unless product

      modifier_strategy = ModifierStrategy.new(product)

      PositionCalculator.new(
        product: product,
        price: pos[:price],
        quantity: pos[:quantity],
        loyalty_strategy: @loyalty,
        modifier_strategy: modifier_strategy
      )
    end

    results        = pos_calculators.map(&:result)
    total_raw      = results.sum { |r| r[:value] }
    total_discount = results.sum { |r| r[:discount_value] }
    total_cashback = results.sum { |r| r[:cashback_value] }
    total_price    = total_raw - total_discount
    bonus_max = pos_calculators.select(&:loyalty_eligible?).sum(&:raw_sum)

    {
      status: 'success',
      user_info: user_info,
      operation_id: create_operation(total_price, total_discount, total_cashback, bonus_max),
      total_price: total_price.round(2),
      bonus_info: {
        balance: @user.bonus,
        available_to_spend: bonus_max.round(2),
        cashback_percent: @loyalty.percent_cashback,
        cashback_earned: total_cashback.round(2)
      },
      discount_info: {
        total_discount: total_discount.round(2),
        discount_percent: @loyalty.percent_discount
      },
      positions: results
    }
  end

  private

  def user_info
    { id: @user.id, name: @user.name, loyalty_level: @user.template.name }
  end

  def create_operation(total_price, total_discount, total_cashback, bonus_max)
    DB[:operations].insert(
      user_id: @user.id,
      cashback: total_cashback.round(2),
      cashback_percent: @loyalty.percent_cashback,
      discount: total_discount.round(2),
      discount_percent: @loyalty.percent_discount,
      write_off: 0,
      check_summ: total_price.round(2),
      done: false,
      allowed_write_off: bonus_max.round(2)
    )
  end
end
