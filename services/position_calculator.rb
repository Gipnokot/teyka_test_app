# frozen_string_literal: true

# services/position_calculator.rb

# Сервис для расчёта скидки и кэшбэка по одной позиции товара,
# используется внутри OperationService при обходе всех позиций чека.
class PositionCalculator
  def initialize(product:, price:, quantity:, loyalty_strategy:, modifier_strategy:)
    @product         = product
    @price           = price.to_f
    @quantity        = quantity.to_i
    @loyalty_strat   = loyalty_strategy
    @modifier_strat  = modifier_strategy
  end

  # расчет итоговой стоимости по позиции
  def result
    {
      id: @product.id, # id товара
      type: @product&.type, # модификатор лояльности
      value: raw_sum, # общая сумма без скидок
      discount_percent: total_discount_percent, # общий % скидки
      discount_value: discount.round(2), # сумма скидки
      cashback_percent: total_cashback_percent, # общий % кэшбэка
      cashback_value: cashback.round(2) # сумма кэшбэка
    }
  end

  # общая стоимость без скидки
  def raw_sum
    @price * @quantity
  end

  # общая сумма скидки
  def total_discount_percent
    base = (@product.type == 'noloyalty' ? 0 : @loyalty_strat.percent_discount)
    base + @modifier_strat.percent_discount
  end

  # общая сумма кэшбэка
  def total_cashback_percent
    base = (@product.type == 'noloyalty' ? 0 : @loyalty_strat.percent_cashback)
    base + @modifier_strat.percent_cashback
  end

  # сумма скидки по позиции
  def discount
    raw_sum * (total_discount_percent / 100.0)
  end

  # сумма кэшбэка по позиции
  def cashback
    raw_sum * (total_cashback_percent / 100.0)
  end
end
