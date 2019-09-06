class Api::V1::ProductsController < Api::V1::BaseController
  before_action :find_resoucre, only: %i[destroy update]
  before_action :sanitize_params, only: %i[create update]

  def create
    authorize! :create, Product, message: "You don't have right to build the product."
    result = ProductForm.in_create(product_resource).submit
    
    respond_with result
  end

  def index
    products = if query_params.empty? 
      Product.all
    else
      relation = Product.find_by_category(query_params['category']) if query_params['category']
      relation.all
    end 

    products.each do |product|
      authorize! :index, product
    end

    respond_with Result.new(status: 200, body: products)
  end

  def update
    authorize! :update, @targeted_resource, message: "You don't have right to modify the product."
    result = ProductForm.in_update(@targeted_resource, attributes: product_params).submit

    respond_with result
  end

  def destroy
    authorize! :destroy, @targeted_resource, message: "You don't have right to modify the product."

    message = "Product (#{resource_id}) cann't be deleted."
    status = 422
    if @targeted_resource.destroy
      message = "Product (#{resource_id}) has been already deleted."
      status = 200
    end

    respond_with Result.new(status: status, body: message)
  end

  private

  def query_params
    params.permit(:category, :price, :quantity)
  end

  def sanitize_params
    product_params[:price] = product_params[:price].to_f if product_params[:price]
    product_params[:quantity] = product_params[:quantity].to_i if product_params[:quantity]
  end

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :image_url, :category_id)
  end

  def product_resource
    Product.new(product_params)
  end
end
