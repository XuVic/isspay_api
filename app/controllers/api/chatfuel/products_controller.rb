module Api::Chatfuel
  class ProductsController < BaseController
    def index
      products.each do |product|
        authorize! :index, product
      end

      message = ChatfuelJson::Response.new(resources: products, messenger_id: messenger_id)
      message.body_to(:products_gallery)
      render_json message
    end

    private

    def products
      Product.find_by_category(category)
    end

    def product_params
      params.require(:product).permit(:category)
    end

    def category
      product_params[:category]
    end
  end
end
