class AccountRepay < Service
  
  def call!
    check_unpaid_amount
    sql_transaction do
      clear_transaction
      clear_account
    end
  rescue => e
    raise ServiceError.new(e.message)
  end

  private

  def check_unpaid_amount
    order_amount = account.orders.unpaid.reduce(0) { |sum, o| sum += o.amount }
    raise ServiceError.new('Account balance is not correct') if account.balance != order_amount * -1
  end

  def clear_transaction
    account.orders.unpaid.map(&:pay!)
  end

  def clear_account
    account.update!(balance: 0) if account.balance.negative?
    account
  end

  def account
    user.account
  end
end