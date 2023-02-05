# frozen_string_literal: true

require 'sinatra'

module ExpenseTracker
  class API < Sinatra::Base
    get '/' do
      'Hello, World!'
    end
  end
end
