class Api::V1::TransactionsController < Api::V1::BaseController
  def index
    transactions.each { |t| authorize! :read, t }
    
    render_json transactions, type: :resource
  end

  private

  def transactions
    Transaction.where(account_id: current_user.account.id).all
  end
end
