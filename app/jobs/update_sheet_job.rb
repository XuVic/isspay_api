class UpdateSheetJob < ApplicationJob
  ADAPTERS = {
    google: GoogleSheetAdapter
  }

  attr_reader :gateway

  def perform(adapter, sync)
    @gateway = ADAPTERS[adapter.to_sym].new
    update_products_from_sheet unless sync
    update_sheet_from_db
  end

  private
  
  def update_products_from_sheet
    results = @gateway.read_all('Products')
    add_records = results.select { |p| p.quantity.to_i >= 0 }
    destroy_records = results.select { |p| p.quantity.to_i < 0 }
    Product.upsert_all(add_records, unique_by: :name) if add_records.present?
    Product.destroy(destroy_records.map(&:id)) if destroy_records.present?
  end

  def update_sheet_from_db
    update_products
    update_users
    update_transactions
  end

  def update_products
    products = Product.all
    if products.exists?
      @gateway.clear_page('Products')
      @gateway.write_all(products)
    end
  end

  def update_users
    users = User.all
    if users.exists?
      @gateway.clear_page('Users')
      @gateway.write_all(users)
    end
  end

  def update_transactions
    transactions = Transaction.includes(:account, :purchased_products).all
    if transactions.exists?
      @gateway.clear_page('Transactions')
      @gateway.write_all(transactions)
    end
  end
end