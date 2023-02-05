# frozen_string_literal: true

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      id = DB[:expenses].insert(expense)
      RecordResult.new(true, id, nil)
    rescue StandardError => e
      RecordResult.new(false, nil, e.message)
    end

    def expenses_on(date)
      DB[:expenses].where(date:).all
    end
  end
end
