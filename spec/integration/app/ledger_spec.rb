# frozen_string_literal: true

module ExpenseTracker
  RSpec.describe Ledger, :aggregate_failures, :db do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
    end

    describe '#recoord' do
      context 'with a valid expense' do
        it 'successfully saves the expense in the DB' do
          result = ledger.record(expense)

          expect(result).to be_success
          expect(DB[:expenses][id: result.expense_id]).to eq({
                                                               id: result.expense_id,
                                                               payee: expense['payee'],
                                                               amount: expense['amount'],
                                                               date: Date.iso8601(expense['date'])
                                                             })
        end
      end

      context 'when expense lacks a payee' do
        it 'reject the expense as invalid' do
          expense.delete('payee')

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.expense_id).to be_nil
          expect(result.error_message).to include('payee')
          expect(DB[:expenses].count).to eq(0)
        end
      end
    end

    describe '#expenses_on' do
      it 'returns all expenses for the provided date' do
        result1 = ledger.record(expense.merge('date' => '2017-06-10'))
        result2 = ledger.record(expense.merge('date' => '2017-06-10'))
        ledger.record(expense.merge('date' => '2017-06-11'))
        expect(ledger.expenses_on('2017-06-10')).to contain_exactly(
          a_hash_including(id: result1.expense_id),
          a_hash_including(id: result2.expense_id)
        )
      end

      it 'returns a blank array when there are no matching expenses' do
        expect(ledger.expenses_on('2017-06-10')).to eq([])
      end
    end
  end
end
