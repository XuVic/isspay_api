class DeleteTransaction < BaseService
  attr_reader :transaction

  def initialize(user, transaction)
    super(user)
    @transaction = transaction
  end

  def call
    delete_purchase if transaction.genre == 'purchase'
    delete_transfer if transaction.genre == 'transfer'
    
    super()
  rescue ServiceHalt
    @result
  end

  def delete_purchase
    sql_transaction do
      inventory_increment
      balance_increment
      destroy_transaction
    end
  end

  def delete_transfer
    sql_transaction do
      receiver_decrement
      balance_increment
      destroy_transaction
    end
  end
  
  private

  def inventory_increment
    PurchasedProduct.where(transaction_id: transaction.id).all.each do |purchased|
      product = purchased.product
      product.increment!(:quantity, size = purchased.quantity)
    end
  end

  def balance_increment
    transaction.account.decrement!(:debit, size = transaction.amount)
  end

  def receiver_decrement
    transaction.transfer_details.each do |transfer|
      transfer.receiver.decrement!(:credit, size = transfer.amount)
    end
  end

  def balance_increment
    transaction.account.decrement!(:debit, size = transaction.amount)
  end

  def destroy_transaction
    msg = "Transaction #{transaction.id} has been destroied."
    
    transaction.products.delete_all if transaction.genre == 'purchase'
    transaction.receivers.delete_all if transaction.genre == 'transfer'

    @result = Result.new(status: 200, body: msg)if transaction.destroy
  end
end