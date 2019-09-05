class CreateTransaction < BaseService
  attr_reader :form

  def initialize(user, form)
    super(user)
    @form = form
  end

  def call
    create_purchase if form.purchase?
    create_transfer if form.transfer?
    
    super()
  rescue ServiceHalt
    @result
  end

  def create_purchase
    validate_products

    sql_transaction do
      create_transaction('purchase')
      decrease_account_balance
      decrease_products_quantity
    end
  end

  def create_transfer
    validate_transfer

    sql_transaction do
      create_transaction('transfer')
      decrease_account_balance
      increase_receiver_balance
    end
  end 
  
  private
  
  def validate_products
    purchase_products = form.valid_purchases
    
    if purchase_products.nil?
      @result = Result.new(status: 404, body: form.errors.full_messages)
      raise ServiceHalt
    else
      data[:purchase_products] = purchase_products
    end
  end

  def create_transaction(genre)
    transaction = Transaction.create(account: @user.account, genre: genre)
    
    transaction.purchased_products_attributes = data[:purchase_products].map {|p| p.slice(:product_id, :quantity)} if transaction.genre == 'purchase'
    transaction.transfer_details_attributes = data[:transfers_detail].map {|t| t.slice(:receiver_id, :amount)} if transaction.genre == 'transfer'


    transaction.save
    data[:transaction] = transaction
  end

  def decrease_account_balance
    user.account.pay!(data[:transaction].amount)
  end

  def decrease_products_quantity
    data[:purchase_products].each do |product_params|
      product_params['product'].decrement!(:quantity, size = product_params['quantity'])
    end

    @result = Result.new(status: 201, body: data[:transaction])
  end

  def validate_transfer
    transfers_detail = form.valid_transfers

    if transfers_detail.nil?
      @result = Result.new(status: 404, body: form.errors.full_messages)
      raise ServiceHalt
    else
      data[:transfers_detail] = transfers_detail
    end
  end

  def increase_receiver_balance
    data[:transfers_detail].each do |transfer|
      transfer['receiver'].account.receive!(transfer['amount']) 
    end

    @result = Result.new(status: 201, body: data[:transaction])
  end
end