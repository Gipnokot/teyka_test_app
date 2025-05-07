# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Operation, type: :model do
  let(:user) { create(:user) }

  it 'is valid with all required fields' do
    operation = create(:operation, user: user)
    expect(operation).to be_valid
  end

  it 'is invalid without a user_id' do
    operation = build(:operation, user: nil, user_id: nil)
    expect(operation).not_to be_valid
  end

  it 'is invalid without cashback' do
    operation = build(:operation, cashback: nil, user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if cashback is not a number' do
    operation = build(:operation, cashback: 'invalid', user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid without cashback_percent' do
    operation = build(:operation, cashback_percent: nil, user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if cashback_percent is not a number' do
    operation = build(:operation, cashback_percent: 'invalid', user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid without discount' do
    operation = build(:operation, discount: nil, user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if discount is not a number' do
    operation = build(:operation, discount: 'invalid', user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid without discount_percent' do
    operation = build(:operation, discount_percent: nil, user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if discount_percent is not a number' do
    operation = build(:operation, discount_percent: 'invalid', user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid without check_summ' do
    operation = build(:operation, check_summ: nil, user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if check_summ is not a number' do
    operation = build(:operation, check_summ: 'invalid', user: user)
    expect(operation).not_to be_valid
  end

  it 'is invalid if user_id is not an integer' do
    operation = build(:operation, user: user, user_id: 'abc')
    expect(operation).not_to be_valid
  end

  it 'is valid if write_off is nil' do
    operation = create(:operation, write_off: nil, user: user)
    expect(operation).to be_valid
  end

  it 'is valid if allowed_write_off is nil' do
    operation = create(:operation, allowed_write_off: nil, user: user)
    expect(operation).to be_valid
  end

  it 'is valid if done is nil' do
    operation = create(:operation, done: nil, user: user)
    expect(operation).to be_valid
  end

  it 'is valid if done is true' do
    operation = create(:operation, done: true, user: user)
    expect(operation).to be_valid
  end

  it 'is valid if done is false' do
    operation = create(:operation, done: false, user: user)
    expect(operation).to be_valid
  end

  it 'belongs to a user' do
    operation = create(:operation, user: user)
    expect(operation.user).to eq(user)
  end
end
