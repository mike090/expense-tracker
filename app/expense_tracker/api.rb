# frozen_string_literal: true

require 'sinatra/base'

module ExpenseTracker
  class API < Sinatra::Base
    post '/expenses' do
      JSON.generate({ expense_id: 47 })
    end

    get '/expenses/:date' do
      JSON.generate([])
    end
  end
end
