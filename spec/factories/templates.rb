# frozen_string_literal: true

FactoryBot.define do
  factory :template do
    to_create(&:save)
    name { 'Silver' }
    discount { 5 }
    cashback { 5 }
  end
end
