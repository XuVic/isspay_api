class Api::V1::ProductsController < Api::V1::BaseController
  before_action :find_product, only: %i[destroy update]

  def create
  end

  def index
    products = Product.all
    
    products.each do |product|
      authorize! :index, product
    end
    
    render_json products, type: :resource
  end

  def update
  end

  def destroy
    authorize! :destroy, @targeted_product, message: "You don't have right to destroy the product."
    
    if @targeted_product.destroy
      deleted_message = "Product(#{product_id}) has been already deleted."
      render_json deleted_message, type: :message
    else
      error_message = "Product(#{product_id}) cann't be deleted."
      render_json error_message, type: :error
    end
  end

  private

  def product_id
    params.permit(:id)[:id]
  end

  def find_product
    @targeted_product = Product.find(product_id)
  end
end
