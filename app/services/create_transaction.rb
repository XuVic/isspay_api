class CreateTransaction < BaseService

  def initialize(user, product_params)
    super(user)
    @product_params = product_params['products'].sort_by { |p| p['id'] }
  end

  def call
    validate_products()
    sql_transaction do
      create_transaction()
      decrease_account_balance()
      decrease_products_quantity()
    end
    @result
  rescue => e
    Result.new(staus: 404, body: 'Transaction cannot be created.')
  end

  private
  
  def validate_products
    find_products
    messages = []
    @purchase_products = []
    @products.each_with_index do |p, i|
      messages << "#{p.name} out of stock" if p.quantity < @product_params[i]['quantity']
      @purchase_products += @product_params[i]['quantity'].times.map { p.clone } 
    end
    
    @result = Result.new(status: 404, body: messages) unless messages.empty?
  end

  def create_transaction
    return @result if @result

    @transaction = Transaction.create(account: @user.account, genre: 'purchase')
    @transaction.products = @purchase_products
    @transaction.save
  end

  def decrease_account_balance
    return @result if @result

    @user.account.pay!(@transaction.amount)
  end

  def decrease_products_quantity
    return @result if @result
  
    @products.each_with_index do |p, i|
      p.decrement!(:quantity, by = @product_params[i]['quantity'])
    end

    @result = Result.new(status: 201, body: @transaction)
  end

  def find_products
    product_ids = @product_params.map {|p| p['id']}
    @products ||= Product.where(id: product_ids).order('id').all
  end
end