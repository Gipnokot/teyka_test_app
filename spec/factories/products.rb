# frozen_string_literal: true

# factories/products.rb
FactoryBot.define do
  sequence(:name) { |n| "Product#{n}" }
  type { 'discount' }
  value { '10' }

  trait :milk do
    name { 'Молоко' }
    type { 'increased_cashback' }
    value { '10' }
  end

  trait :bread do
    name { 'Хлеб' }
    type { 'discount' }
    value { '15' }
  end

  trait :sugar do
    name { 'Сахар' }
    type { 'noloyalty' }
    value { nil }
  end
end
