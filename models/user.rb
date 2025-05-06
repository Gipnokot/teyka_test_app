# frozen_string_literal: true

# models/user.rb
class User < Sequel::Model
  plugin :validation_helpers

  # ассоциации
  many_to_one :template
  one_to_many :operations

  # валидации
  def validate
    super
    validates_presence %i[name template_id]
    validates_type String, :name
    validates_type Integer, :template_id
    validates_type BigDecimal, :bonus, allow_nil: true
    validates_max_length 255, :name
    validates_foreign_key :template_id, :templates
  end
end
