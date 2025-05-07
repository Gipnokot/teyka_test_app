# frozen_string_literal: true

# models/product.rb
class Product < Sequel::Model
  plugin :validation_helpers

  # валидации
  def validate
    super
    validates_presence :name
    validates_type String, %i[name type]
    validates_type(String, :value, allow_nil: true)
    validates_max_length 255, %i[name type]
    validates_max_length 255, :value, allow_nil: true
  end
end
