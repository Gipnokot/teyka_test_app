# frozen_string_literal: true

# spec/models/template_spec.rb
require 'spec_helper'

RSpec.describe Template, type: :model do
  it 'created through a factory' do
    template = create(:template)
    expect(template).to be_a(Template)
    expect(template.name).not_to be_nil
    expect(template.discount).to be_a(Integer)
    expect(template.cashback).to be_a(Integer)
  end

  it 'required field name' do
    template = build(:template, name: nil)
    expect(template).not_to be_valid
  end

  it 'required fields discount and cashback' do
    template = build(:template, discount: nil, cashback: nil)
    expect(template).not_to be_valid
  end

  it 'is invalid if name is not a string' do
    template = build(:template, name: [:symbol])
    expect(template).not_to be_valid
  end

  it 'is invalid if discount is not an integer' do
    template = build(:template, discount: 'five')
    expect(template).not_to be_valid
  end

  it 'is invalid if cashback is not an integer' do
    template = build(:template, cashback: 'ten')
    expect(template).not_to be_valid
  end

  it 'is invalid if name is too long' do
    template = build(:template, name: 'a' * 256)
    expect(template).not_to be_valid
  end

  describe 'associations' do
    it 'has many users' do
      template = create(:template)
      user1 = create(:user, template: template)
      user2 = create(:user, template: template)
      expect(template.users).to include(user1, user2)
    end
  end
end
