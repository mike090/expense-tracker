# frozen_string_literal: true

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  ByDateResult = Struct.new(:expenses)

  class Ledger
    def record(expense); end
    def by_date(date); end
  end
end
