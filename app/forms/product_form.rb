class ProductForm < BaseForm
  
  delegate :name, :price, :quantity, :image_url, :category_id, to: :target_resource
  
end