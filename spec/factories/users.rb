# frozen_string_literal: true

# factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    bonus { 10_000 }
    template

    trait :ivan do
      name { 'Иван' }
      template { association :template, :bronze }
    end

    trait :marina do
      name { 'Марина' }
      template { association :template, :silver }
    end

    trait :zhenya do
      name { 'Женя' }
      template { association :template, :gold }
    end
  end
end
