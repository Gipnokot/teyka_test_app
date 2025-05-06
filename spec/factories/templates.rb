# frozen_string_literal: true

# factories/templates.rb
FactoryBot.define do
  factory :template
  sequence(:name) { |n| "Template#{n}" }
  discount { 5 }
  cashback { 5 }

  trait :bronze do
    name { 'Bronze' }
    discount { 0 }
    cashback { 5 }
  end

  trait :silver do
    name { 'Silver' }
    discount { 5 }
    cashback { 5 }
  end

  trait :gold do
    name { 'Gold' }
    discount { 15 }
    cashback { 0 }
  end
end
