class TransactionForm < Form
  alias params resource

  def submit!
    raise FormInvalid.new(errors) unless valid?
    t = Transaction.create!(genre: params[:genre], account_id: params[:account_id])
    t.purchased_products_attributes = params[:purchased_products_attributes] if params[:purchased_products_attributes]
    t.transfer_details_attributes = params[:transfer_details_attributes] if params[:transfer_details_attributes]
    t if t.set_amount!
  end

  def purchase_validation
    @purchase_errors = Hash.new([])
    validate_products(params[:purchased_products_attributes]) if params[:purchased_products_attributes].present?
    errors.add(:base, :blank_purchase, message: "Purchased product should not be empty.") unless params[:purchased_products_attributes].present?
    errors.add(:base, :not_found, message: "Products (#{@purchase_errors[:missing]}) cannot be found") if @purchase_errors[:missing].present?
    errors.add(:base, :insufficient_products, message: "Products (#{@purchase_errors[:insufficient]}) are insufficient.") if @purchase_errors[:insufficient].present?
  end

  def transfer_validation
    @transfer_errors = Hash.new([])
    validate_transfers(params[:transfer_details_attributes]) if params[:transfer_details_attributes].present?
    errors.add(:base, :blank_transfer, message: "Transfer detail should not be empty.") unless params[:transfer_details_attributes].present?
    errors.add(:base, :not_found, message: "Receivers (#{@transfer_errors[:missing]}) cannot be found") if @transfer_errors[:missing].present?
    errors.add(:base, :negative_amount, message: "Receivers (#{@transfer_errors[:negative]}) cannot be transfer with negative amount.") if @transfer_errors[:negative].present?
  end

  def valid?
    errors.add(:base, :genre_not_blank, message: "Genre cannnot be blank") unless params[:genre].present?
    purchase_validation if genre == 'purchase'
    transfer_validation if genre == 'transfer'
    errors.full_messages.empty?
  end

  private

  def genre
    params[:genre]
  end

  def validate_products(purchased_products)
    purchased_products.each do |purchase|
      product = Product.where(id: purchase[:product_id]).first
      if product
        @purchase_errors[:insufficient].append(purchase[:product_id]) if product.quantity < purchase[:quantity]
      else
        @purchase_errors[:missing].append(purchase[:product_id])
      end
    end
  end

  def validate_transfers(transfer_details)
    transfer_details.each do |transfer_detail|
      account = Account.where(id: transfer_detail[:receiver_id]).first
      @transfer_errors[:missing].append(transfer_detail[:receiver_id]) unless account
      @transfer_errors[:negative].append(transfer_detail[:receiver_id]) if transfer_detail[:amount].negative?
    end
  end
end