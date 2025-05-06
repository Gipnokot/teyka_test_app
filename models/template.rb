# frozen_string_literal: true

# models/template.rb
class Template < Sequel::Model
  plugin :validation_helpers

  # ассоциации
  one_to_many :users

  # валидации
  def validate
    super
    validates_presence %i[name discount cashback]
    validates_type String, :name
    validates_type Integer, %i[discount cashback]
    validates_max_length 255, :name
  end
end
