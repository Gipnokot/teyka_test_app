# frozen_string_literal: true

class OperationConfirmationService
  def initialize(operation_id, write_off_amount)
    @operation_id = operation_id
    @write_off = write_off_amount.to_f.round(2)
  end

  def call
    validate_operation_and_user
    new_balance, final_price = calculate_new_values
    update_database(new_balance, final_price)
    build_response(new_balance, final_price)
  end

  private

  def validate_operation_and_user
    @operation = DB[:operations][id: @operation_id] or raise 'Операция не найдена'
    raise 'Операция уже подтверждена' if @operation[:done]

    @user = User[@operation[:user_id]] or raise 'Пользователь не найден'
    raise 'Недостаточно бонусных баллов на балансе' if @write_off > @user.bonus
    raise 'Сумма списания должна быть положительной' if @write_off.negative?
    raise 'Списание превышает допустимый лимит' if @write_off > @operation[:allowed_write_off]
  end

  def calculate_new_values
    new_balance = (@user.bonus - @write_off + @operation[:cashback]).round(2)
    final_price = (@operation[:check_summ] - @write_off).round(2)
    final_price = 0 if final_price.negative?
    [new_balance, final_price]
  end

  def update_database(new_balance, final_price)
    DB.transaction do
      @user.update(bonus: new_balance)
      DB[:operations].where(id: @operation_id).update(
        done: true,
        write_off: @write_off,
        check_summ: final_price
      )
    end
  end

  def build_response(new_balance, final_price)
    {
      status: 'confirmed',
      operation_id: @operation_id,
      user_id: @user.id,
      new_bonus_balance: new_balance,
      cashback_applied: @operation[:cashback],
      write_off_applied: @write_off,
      final_price: final_price
    }
  end
end
