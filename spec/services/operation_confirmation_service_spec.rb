# frozen_string_literal: true

require 'spec_helper'
require_relative '../../services/operation_confirmation_service'

RSpec.describe OperationConfirmationService do
  subject { described_class.new(operation.id, write_off_amount) }

  let!(:user) { create(:user, bonus: 500.to_d) }
  let!(:operation) do
    create(:operation,
           user: user,
           cashback: 30.to_d,
           allowed_write_off: 200.to_d,
           check_summ: 1000.to_d,
           done: false,
           write_off: 0.to_d)
  end

  context 'when operation is successfully confirmed' do
    let(:write_off_amount) { 150.0 }

    it 'updates the operation and user bonus correctly' do
      result = subject.call

      expect(result[:status]).to eq('confirmed')
      expect(result[:operation_id]).to eq(operation.id)
      expect(result[:user_id]).to eq(user.id)
      expect(result[:write_off_applied]).to eq(150.0)
      expect(result[:final_price]).to eq(850.0)
      expect(result[:new_bonus_balance]).to eq(380.0) # 500 - 150 + 30

      updated_op = Operation[operation.id]
      expect(updated_op.done).to be true
      expect(updated_op.write_off).to eq(150.0)
      expect(updated_op.check_summ).to eq(850.0)
    end
  end

  context 'when operation does not exist' do
    subject { described_class.new(9999, write_off_amount) }

    let(:write_off_amount) { 50.0 }

    it 'raises "Operation not found" error' do
      expect { subject.call }.to raise_error('Операция не найдена')
    end
  end

  context 'when operation is already confirmed' do
    let(:write_off_amount) { 50.0 }

    before do
      operation.update(done: true)
    end

    it 'raises "Operation already confirmed" error' do
      expect { subject.call }.to raise_error('Операция уже подтверждена')
    end
  end

  context 'when write-off exceeds allowed limit' do
    let(:write_off_amount) { 250.0 }

    it 'raises "Write-off exceeds allowed limit" error' do
      expect { subject.call }.to raise_error('Списание превышает допустимый лимит')
    end
  end

  context 'when user has insufficient bonus' do
    let(:write_off_amount) { 600.0 }

    it 'raises "Insufficient bonus balance" error' do
      expect { subject.call }.to raise_error('Недостаточно бонусных баллов на балансе')
    end
  end
end
