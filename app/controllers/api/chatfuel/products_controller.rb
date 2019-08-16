module Api::Chatfuel
  class ProductsController < BaseController
    prepend_before_action :sanitize_params, only: :index

    def index
      products.each do |product|
        authorize! :index, product
      end

      message = ChatfuelJson::Response.new(resources: products, messenger_id: messenger_id)
      
      if products.empty? 
        message.body_to(:out_of_stock)
      else
        next_age = out_of_range ? nil : page + 1
        message.body_to(:products_gallery, next_age)
      end

      render_json message
    end

    private

    def out_of_range
      page >= (Product.count / 9.0).ceil
    end

    def products
      Product.find_by_category(category).paginate(page, 9).all
    end

    def product_params
      params.require(:product).permit(:category)
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
