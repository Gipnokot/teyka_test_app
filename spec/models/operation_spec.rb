# factories/operation_spec.rb
RSpec.describe Operation, type: :model do
  let(:user) { create(:user) }

  it 'is valid with all required fields' do
    operation = build(:operation, user: user)
    expect(operation).to be_valid
  end

  it 'is invalid without user_id' do
    operation = build(:operation, user_id: nil)
    expect(operation).not_to be_valid
  end

  %i[cashback cashback_percent discount discount_percent check_summ].each do |field|
    it "is invalid without #{field}" do
      operation = build(:operation, field => nil)
      expect(operation).not_to be_valid
    end

    it "is invalid if #{field} is not a number" do
      operation = build(:operation, field => 'invalid')
      expect(operation).not_to be_valid
    end
  end

  it 'is invalid if user_id is not an integer' do
    operation = build(:operation, user_id: 'abc')
    expect(operation).not_to be_valid
  end

  it 'is valid if write_off is nil' do
    operation = build(:operation, write_off: nil)
    expect(operation).to be_valid
  end

  it 'is valid if allowed_write_off is nil' do
    operation = build(:operation, allowed_write_off: nil)
    expect(operation).to be_valid
  end

  it 'is valid if done is nil' do
    operation = build(:operation, done: nil)
    expect(operation).to be_valid
  end

  it 'is valid if done is true' do
    operation = build(:operation, done: true)
    expect(operation).to be_valid
  end

  it 'is valid if done is false' do
    operation = build(:operation, done: false)
    expect(operation).to be_valid
  end

  it 'belongs to a user' do
    operation = build(:operation, user: user)
    expect(operation.user).to eq(user)
  end
end
