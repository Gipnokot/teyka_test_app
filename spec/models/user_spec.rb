# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    let(:user) { create(:user) }

    it 'creates a valid instance' do
      expect(user).to be_a(described_class)
    end

    it 'has a name' do
      expect(user.name).not_to be_nil
      expect(user.name).to be_a(String)
    end

    it 'has a template_id' do
      expect(user.template_id).not_to be_nil
      expect(user.template_id).to be_a(Integer)
    end

    it 'has a bonus as BigDecimal' do
      expect(user.bonus).to be_a(BigDecimal)
    end
  end

  describe 'validations' do
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
  end

  describe 'associations' do
    it 'belongs to a template' do
      template = create(:template)
      user = create(:user, template: template)
      expect(user.template).to eq(template)
    end
  end
end
