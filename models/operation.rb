# frozen_string_literal: true

# models/operation.rb
class Operation < Sequel::Model
  plugin :validation_helpers

  # ассоциации
  many_to_one :user

  # валидации
  def validate
    super
    validates_presence %i[user_id cashback cashback_percent discount discount_percent check_summ]
    validates_type Integer, :user_id
    validates_type BigDecimal, %i[cashback cashback_percent discount discount_percent check_summ]
    validates_type BigDecimal, :write_off, allow_nil: true
    validates_type BigDecimal, :allowed_write_off, allow_nil: true
    validates_boolean :done, allow_nil: true
    validates_foreign_key :user_id, :users
  end
end
