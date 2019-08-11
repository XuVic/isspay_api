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
    authorize! :update, @targeted_product, message: "You don't have right to modify the product."
    update_form = ProductForm.new(@targeted_product, { attributes: product_params, context: :update })
    result = update_form.submit

    render_form_result result
  end

  def destroy
    authorize! :destroy, @targeted_product, message: "You don't have right to modify the product."
    
    if @targeted_product.destroy
      deleted_message = "Product(#{product_id}) has been already deleted."
      render_json deleted_message, type: :message
    else
      error_message = "Product(#{product_id}) cann't be deleted."
      render_json error_message, type: :error
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :image_url, :category_id)
  end

  def product_id
    params.permit(:id)[:id]
  end

  def find_product
    @targeted_product = Product.find(product_id)
  end
end
