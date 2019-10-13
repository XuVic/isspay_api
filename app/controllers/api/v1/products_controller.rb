class Api::V1::ProductsController < Api::V1::BaseController
  before_action :find_resoucre, only: %i[destroy update]
  before_action :sanitize_params, only: %i[create update]

  def create
    authorize! :create, Product, message: "You don't have right to build the product."
    product = ProductForm.in_create(product_resource).submit!
    
    render_json JsonResponse.new(201, product, type: :resource)
  end

  def update
    authorize! :update, @targeted_resource, message: "You don't have right to modify the product."

    product = ProductForm.in_update(@targeted_resource, attributes: product_params).submit!
    render_json JsonResponse.new(201, product, type: :resource)
  end

  def destroy
    authorize! :destroy, @targeted_resource, message: "You don't have right to modify the product."

    json_response = [422, "Product (#{resource_id}) cann't be deleted."]
    json_response = [200, "Product (#{resource_id}) has been already deleted."] if @targeted_resource.destroy

    render_json JsonResponse.new(json_response[0], json_response[1], type: :message)
  end

  def index
    products = Product.scopes_chain(query_scopes)

    products.each do |product|
      authorize! :index, product, message: "You don't have right to read products."
    end

    render_json JsonResponse.new(200, products, type: :resource) 
  end
  
  private

  def query_scopes
    scopes = []
    query_params.each do |k, v|
      scope = ["#{k}_scope".to_sym, v]
      scopes.append(scope)
    end
    scopes
  end

  def query_params
    @query_params ||= sanitize_query(params.permit(:category, :price, :quantity))
  end

  def sanitize_query(query_params)
    query_params[:category] = Category.where(name: query_params[:category]).first!.id if query_params[:category]
    query_params[:price] = query_params[:price].split(':').map(&:to_i) if query_params[:price]
    query_params[:quantity] = query_params[:quantity].split(':').map(&:to_i) if query_params[:quantity]
    query_params
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
