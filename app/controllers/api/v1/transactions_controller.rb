class Api::V1::TransactionsController < Api::V1::BaseController
  before_action :find_resoucre, only: :destroy

  def index
    transactions.each { |t| authorize! :read, t }
    respond_with Result.new(status: 200, body: transactions)
  end

  def create
    result = CreateTransaction.new(current_user, create_form).call
   
    respond_with result
  end

  def destroy
    authorize! :destroy, @targeted_resource
    result = DeleteTransaction.new(current_user, @targeted_resource).call
    
    respond_with result
  end

  private

  def genre
    params.require(:transaction).require(:genre)
  end

  def create_form
    if genre == 'purchase'
      TransactionForm.purchase_products(current_user, purchase_params)
    elsif genre == 'transfer'
      TransactionForm.transfer_money(current_user, transfer_params)
    end
  end

  def transactions
    unless query_params.empty?
      return @transactions ||= filter_transactions
    end

    @transactions ||= Transaction.where(account_id: current_user.account.id).all
  end

  def filter_transactions
    transactions = Transaction.where(where_parameter)
    transactions.send(query_params['state'].to_sym) if query_params['state']
    
    if query_params['amount']
      min, max = query_params['amount']
      max = Float::INFINITY if max.nil? 
      transactions = transactions.select do |t|
        t.amount >= min && t.amount <= max
      end
    end
    transactions
  end

  def query_params
    sanitize_query_string
    params.permit(:state, :since, account_ids: [], amount: [])
  end

  def where_parameter
    query_params.slice('since', 'account_ids').keys.inject({}) do |result, key|
      val = query_params[key]
      if key == 'since'
        result['created_at'] = Time.at(val)..Time.now
      elsif key == 'account_ids'
        result['account_id'] = val
      end
      result
    end
  end

  def sanitize_query_string
    return if @sanitized

    params['since'] = params['since'].to_i if params['since']
    params['amount'] = params['amount'].split(':').map(&:to_i) if params['amount']
    @sanitized = true
  end

  def sanitize_purchase_params
    params[:purchases].each do |params|
      params[:quantity] = params[:quantity].to_i
      params
    end
  end

  def purchase_params
    sanitize_purchase_params
    params.permit(purchases: [:product_id, :quantity]).require(:purchases)
  end

  def transfer_params
    santiize_transfer_params
    params.permit(transfers: [:receiver_id, :amount]).require(:transfers)
  end

  def santiize_transfer_params
    params[:transfers].each do |params|
      params[:amount] = params[:amount].to_i
      params
    end
  end
end
