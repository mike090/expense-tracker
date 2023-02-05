# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :expenses do
      primary_key :id
      String :payee, null: false
      Float :amount, null: false
      Date :date, null: false
    end
  end
end
