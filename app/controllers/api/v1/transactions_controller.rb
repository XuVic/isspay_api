class Api::V1::TransactionsController < Api::V1::BaseController
  def index
    transactions.each { |t| authorize! :read, t }
    render_json transactions, type: :resource
  end

  private

  def transactions
    unless query_params.empty?
      return @transactions ||= filter_transactions
    end

    @transactions ||= Transaction.where(account_id: current_user.account.id).all
  end

  def query_params
    sanitize_query_string
    params.permit(:state, :since, account_ids: [], amount: [])
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
end
