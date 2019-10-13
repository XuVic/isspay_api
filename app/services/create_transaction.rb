class CreateTransaction < BaseService
  attr_reader :params

  def initialize(user, params)
    super(user)
    @params = params
  end

  def call!
    sql_transaction do
      create_transaction
      decrease_account_balance
      decrease_products_quantity if genre == "purchase"
      increase_receiver_balance if genre == 'transfer'
      data[:transaction]
    end
  rescue => e
    raise ServiceError.new(e.message)
  end
  
  private

  def genre
    params[:genre]
  end

  def create_transaction
    params[:account_id] = user.account_id
    form =  TransactionForm.in_create(params)
    data[:transaction] = form.submit!
  end

  def decrease_account_balance
    user.account.pay!(data[:transaction].amount)
  end

  def decrease_products_quantity
    purchased_products = data[:transaction].purchased_products
    purchased_products.each do |purchased_product|
      product = purchased_product.product
      product.decrement!(:quantity, purchased_product.quantity)
    end
  end

  def increase_receiver_balance
    transfer_details = TransferDetail.includes(:receiver).where(transaction_id: data[:transaction].id).all

    transfer_details.each do |transfer_detail|
      account = transfer_detail.receiver
      account.increment!(:credit, transfer_detail.amount)
    end
  end
end