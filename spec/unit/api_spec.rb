# frozen_string_literal: true

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger_stub)
    end

    let(:ledger_stub) { instance_double 'ExpenseTracker::Ledger' }
    let(:expense) { { 'some' => 'data' } }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        before do
          allow(ledger_stub).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed['expense_id']).to eq(417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        before do
          allow(ledger_stub).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, nil, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          expect(parsed['message']).to eq('Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        let(:expenses) do
          [
            { 'expense_id' => 1, 'payee' => 'Starbax', 'amount' => 5.75, 'date' => '2017-06-10' },
            { 'expense_id' => 2, 'payee' => 'Zoo', 'amount' => 15.25, 'date' => '2017-06-10' }
          ]
        end

        before do
          allow(ledger_stub).to receive(:expenses_on)
            .and_return(expenses)
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-10'
          parsed = JSON.parse(last_response.body)
          expect(parsed).to contain_exactly(*expenses)
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-10'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger_stub).to receive(:expenses_on)
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2017-06-15'
          parsed = JSON.parse(last_response.body)
          expect(parsed).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-15'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
