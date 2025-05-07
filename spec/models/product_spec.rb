# frozen_string_literal: true

# spec/models/product_spec.rb
RSpec.describe Product, type: :model do
  it 'created through a factory' do
    product = create(:product)
    expect(product).to be_a(Product)
    expect(product.name).not_to be_nil
    expect(product.name).to be_a(String)
    expect(product.type).to be_a(String)
    expect(product.value).to be_a(String)
  end

  it 'required field name' do
    product = build(:product, name: nil)
    expect(product).not_to be_valid
  end

  it 'is invalid if name is not a string' do
    product = build(:product, name: [:symbol])
    expect(product).not_to be_valid
  end

  it 'is invalid if type is not a string' do
    product = build(:product, type: [:symbol])
    expect(product).not_to be_valid
  end

  it 'is invalid if value is not a string' do
    product = build(:product, value: [:symbol])
    expect(product).not_to be_valid
  end

  it 'is invalid if name is too long' do
    product = build(:product, name: 'a' * 256)
    expect(product).not_to be_valid
  end

  it 'is valid if value is nil' do
    product = build(:product, value: nil)
    expect(product).to be_valid
  end
end
