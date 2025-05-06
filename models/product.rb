# frozen_string_literal: true

# models/product.rb
class Product < Sequel::Model
  plugin :validation_helpers

  # валидации
  def validate
    super
    validates_presence :name
    validates_type String, %i[name type value]
    validates_max_length 255, %i[name type value]
  end
end
