# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  it 'created through a factory' do
    user = create(:user)
    expect(user).to be_a(User)
    expect(user.name).not_to be_nil
    expect(user.name).to be_a(String)
    expect(user.template_id).not_to be_nil
    expect(user.template_id).to be_a(Integer)
    expect(user.bonus).to be_a(BigDecimal)
  end

  it 'requires field name' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid if name is not a string' do
    user = build(:user, name: [:symbol])
    expect(user).not_to be_valid
  end

  it 'is invalid if name is too long' do
    user = build(:user, name: 'a' * 256)
    expect(user).not_to be_valid
  end

  it 'requires field template_id' do
    user = build(:user, template_id: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid if bonus is not a BigDecimal' do
    user = build(:user, bonus: [:symbol])
    expect(user).not_to be_valid
  end

  it 'is valid if bonus is nil' do
    user = build(:user, bonus: nil)
    expect(user).to be_valid
  end

  describe 'associations' do
    it 'belongs to a template' do
      template = create(:template)
      user = create(:user, template: template)
      expect(user.template).to eq(template)
    end
  end
end
