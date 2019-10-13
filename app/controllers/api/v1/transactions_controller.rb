class Api::V1::TransactionsController < Api::V1::BaseController
  before_action :find_resoucre, only: :destroy

  def index
    transactions.each { |t| authorize! :read, t }
    
    render_json JsonResponse.new(200, transactions, type: :resource)
  end

  def create
    transaction = CreateTransaction.new(current_user, transaction_params).call!
   
    render_json JsonResponse.new(201, transaction, type: :resource)
  end

  def destroy
    authorize! :destroy, @targeted_resource
    transaction = DeleteTransaction.new(current_user, @targeted_resource).call!
    
    render_json transaction
  end

  private

  def genre
    params.require(:transaction).require(:genre)
  end


  def transactions
    return @transactions if @transactions
    
    @transactions ||= Transaction.scopes_chain(query_scopes)
    
    if query_params[:amount].present?
      @transactions = @transactions.select do |t|
        t.amount_range(query_params[:amount])
      end
    end

    @transactions
  end

  def query_scopes
    scopes = []
    query_params.each do |k, v|
      scope = ["#{k}_scope".to_sym, v]
      scopes.append(scope) if k != 'amount'
    end
    scopes
  end

  def query_params
    return @query_params if @query_params
  
    sanitize_query_string
    @query_params ||= params.permit(:state, :since, :before, :genre, account_ids: [], amount: [])
  end

  def sanitize_query_string
    params['account_ids'] = [current_user.account_id] if params['account_ids'].nil?
    params['account_ids'].append(current_user.account_id) if params['account_ids'].is_a?(Array) && !params['account_ids'].include?(current_user.account_id)
    params['since'] = params['since'].to_i if params['since']
    params['amount'] = params['amount'].split(':').map(&:to_i) if params['amount']
  end

  def transaction_params
    sanitize_transaction_params
    params.require(:transaction).permit(:genre, purchased_products_attributes: [:product_id, :quantity], transfer_details_attributes: [:receiver_id, :amount])
  end

  def sanitize_transaction_params
    if params[:transaction][:purchased_products_attributes]
      params[:transaction][:purchased_products_attributes].each do |purchase_param|
        purchase_param[:quantity] = purchase_param[:quantity].to_i
      end
    end

    if params[:transaction][:transfer_details_attributes]
      params[:transaction][:transfer_details_attributes].each do |transfer_params|
        transfer_params[:amount] = transfer_params[:amount].to_i
      end
    end
  end
end
