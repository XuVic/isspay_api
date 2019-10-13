module Resource
  class ProductSerializer < BaseSerializer
    attributes :name, :price, :quantity, :category_name, :image_url
  end
end
