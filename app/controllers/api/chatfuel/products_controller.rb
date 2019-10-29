module Api::Chatfuel
  class ProductsController < BaseController
    prepend_before_action :sanitize_params, only: :index

    def index
      products.each do |product|
        authorize! :index, product
      end

      message = ChatfuelJson::Response.new(resources: products, messenger_id: messenger_id)
    end

    def create
      authorize! :create, Product
    
      record = ProductForm.in_create(Product.new(product_params)).submit!

      render_msg :product_created, record
    end

    private

    def out_of_range
      page >= (Product.count / 9.0).ceil
    end

    def products
      Product.available.find_by_category(category).paginate(page, 9).all
    end

    def product_params
      params.require(:product).permit(:category, :name, :quantity, :price, :image_url)
    end

    def page
      params.require(:page)
    end

    def category
      product_params[:category]
    end

    def sanitize_params
      params[:page] = params[:page].to_i
    end
  end
end
