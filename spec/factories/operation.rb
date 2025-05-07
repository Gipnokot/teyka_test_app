# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    user
    cashback         { BigDecimal('0') }
    cashback_percent { BigDecimal('0') }
    discount         { BigDecimal('0') }
    discount_percent { BigDecimal('0') }
    write_off        { nil }
    check_summ       { BigDecimal('100') }
    done             { false }
    allowed_write_off { nil }
  end
end
