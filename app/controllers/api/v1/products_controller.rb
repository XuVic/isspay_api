class Api::V1::ProductsController < Api::V1::BaseController
  before_action :find_product, only: %i[destroy update]
  
  def create

  end

  def index
    products = Product.all
    render products
  end

  def update
  end

  def destroy
    @targeted_product.destroy
  end

  private

  def find_product
    product_id = params.permit(:id)[:id]
    @targeted_product = Product.find(product_id)
  end
end
