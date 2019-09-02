module Resource
  class TransactionSerializer < BaseSerializer
    attributes :created_at, :updated_at, :genre, :state, :amount
  end
end
