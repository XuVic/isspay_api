module Api::Chatfuel
  class ProductsController < BaseController
    prepend_before_action :sanitize_params, only: :index

    def index

      products.each do |product|
        authorize! :index, product
      end

      if products.exists?
        render_msg :products_gallery, [products, page]
      else
        render_msg :text, [['沒有庫存了']]
      end
    end

    def update_sheet
      authorize! :update, Product

      UpdateSheetJob.perform_later(:google)

      render_msg :text,  [["更新中，大約花費3~5sec"]]
    end

    private

    def out_of_range
      page >= (Product.count / 9.0).ceil
    end

    def products
      Product.quantity_scope([1]).category_scope(category).paginate(page, 9).all
    end

    def page
      params.require(:page).to_i
    end

    def category
      params.require(:product).require(:category)
    end
  end
end
