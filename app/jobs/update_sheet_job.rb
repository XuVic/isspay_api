class UpdateSheetJob < ApplicationJob
  ADAPTERS = {
    google: GoogleSheetAdapter
  }

  attr_reader :gateway

  def perform(adapter)
    @gateway = ADAPTERS[adapter.to_sym].new
    update_products_from_sheet
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
    products = Product.all
    @gateway.clear_page('Products')
    @gateway.write_all(products)
  end
end