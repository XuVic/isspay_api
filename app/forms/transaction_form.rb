class TransactionForm < BaseForm
  attr_reader :user, :products

  def initialize(user, products)
    @user = user
    @products = products
  end

  def valid?
    # errors.add(:base, :insufficient_balance, message: "Insufficient Balance.") if insufficient_balance?
    errors.add(:base, :insufficient_inventory, message: 'Insufficient Inventory') if insufficient_inventory?
    errors.full_messages.empty?
  end

  def submit
    if valid?
      @user.order(products, allowed: true)
    else
      errors
    end
  end

  def insufficient_balance?
    user.balance < total_cost
  end

  def insufficient_inventory?
    result = false
    
    @products.each do |product|
      result = true unless product.available?
    end

    result
  end

  def total_cost
    products.reduce(0) { |c, p| c + p.price }
  end
end