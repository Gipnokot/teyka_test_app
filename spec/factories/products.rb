# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Sample Product' }
    type { 'discount' }
    value { '10' }
  end
end
