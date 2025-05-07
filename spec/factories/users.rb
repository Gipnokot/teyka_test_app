# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    bonus { BigDecimal('10000') }
    template { create(:template) }
  end
end
