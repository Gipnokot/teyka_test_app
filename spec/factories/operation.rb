# frozen_string_literal: true

# factories/operations.rb
FactoryBot.define do
  factory :operation do
    user { create(:user) }
    cashback { 10.5 }
    cashback_percent { 5.0 }
    discount { 15.0 }
    discount_percent { 10.0 }
    check_summ { 100.0 }
    write_off { nil }
    allowed_write_off { nil }
    done { false }
  end
end


