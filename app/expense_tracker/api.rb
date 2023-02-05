# frozen_string_literal: true

require 'sinatra/base'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)
      if result.success?
        JSON.generate(expense_id: result.expense_id)
      else
        status 422
        JSON.generate(message: result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate(@ledger.by_date(params[:date]).expenses)
    end
  end
end
