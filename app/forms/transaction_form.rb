class TransactionForm < BaseForm
  attr_reader :user, :params, :context, :products

  class << self
    def purchase_products(user , purchase_params)
      purchase_params.sort_by! { |p| p['product_id'] }
      self.new(user, purchase_params, :purchase)
    end
  
    def transfer_money(user, transfer_params)
      transfer_params.sort_by! { |t| t['receiver_id'] }
      self.new(user, transfer_params, :transfer)
    end
  end

  def initialize(user, params, context)
    @user = user
    @params = params
    @context = context
  end

  def valid_purchases
    purchase_products if valid?
  end

  def valid_transfers
    transfer_receivers if valid?
  end

  def valid?
    if purchase?
      purchase_validation
    elsif transfer?
      transfer_validation
    end
    errors.full_messages.empty?
  end

  def purchase_validation
    errors.add(:base, :not_found, message: "Product (#{missing_products}) cannot be found") if missing_products.present?
    errors.add(:base, :insufficient_inventory, message: insufficient_inventory) if insufficient_inventory.present?
  end

  def transfer_validation
    errors.add(:base, :not_found, message: "Receiver (#{missing_receivers}) cannot be found") if missing_receivers.present?
    errors.add(:base, :amount_negative, message: 'Transfer amount should be positive') if amount_negative?
  end

  def insufficient_inventory
    messages = []
    purchase_products.each do |product_params|
      p = product_params['product']
      messages << "#{p.name} out of stock" if p.quantity <= product_params['quantity']
    end
    messages.join(',')
  end

  def amount_negative?
    transfer_params.each do |t|
      return true if t['amount'].negative?
    end

    false
  end

  def missing_products
    product_ids = purchase_params.map {|p| p['product_id']}
    miss_products = product_ids - products.map(&:id)

    miss_products.join(',')
  end

  def missing_receivers
    receiver_ids = transfer_params.map {|t| t['receiver_id']}
    missing_receivers = receiver_ids - receivers.map(&:id)
    
    missing_receivers.join(',')
  end

  def products
    product_ids = purchase_params.map {|p| p['product_id']}
    @products ||= Product.where(id: product_ids).order('id').all
  end

  def receivers
    receiver_ids = transfer_params.map {|t| t['receiver_id']}
    @receivers ||= User.where(id: receiver_ids).order('id').all
  end

  def purchase_products
    return @purchase_prodcuts if @purchase_prodcuts

    @purchase_prodcuts = []
    purchase_params.each_with_index do |param, i|
      param['product'] = products[i]
      @purchase_prodcuts << param
    end
    @purchase_prodcuts
  end

  def transfer_receivers
    transfer_receivers = []
    transfer_params.each_with_index do |param, i|
      param['receiver'] = receivers[i]
      transfer_receivers << param
    end
    transfer_receivers
  end

  def transfer_params
    return params if transfer?
  end

  def purchase_params
    return params if purchase?
  end

  def purchase?
    context == :purchase
  end

  def transfer?
    context == :transfer
  end
end