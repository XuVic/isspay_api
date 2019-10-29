class DeleteTransaction < Service
  attr_reader :transaction

  def initialize(transaction)
    @transaction = transaction
  end

  
  def call!
    sql_transaction do
      inventory_increment if transaction.purchase?
      receiver_decrement if transaction.transfer?
      balance_increment
      destroy_transaction
    end
  rescue => e
    raise ServiceError.new(e.message)
  end

  private

  def inventory_increment
    transaction.purchased_products.each do |purchased_product|
      product = purchased_product.product
      product.increment!(:quantity, size = purchased_product.quantity)
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

  def destroy_transaction
    transaction.products.delete_all if transaction.genre == 'purchase'
    transaction.receivers.delete_all if transaction.genre == 'transfer'
    transaction.destroy!
  end
end