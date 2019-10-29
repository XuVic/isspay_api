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

      UpdateSheetJob.perform_later(:google, sync)

      message = sync ? ['資料庫同步中'] : ['資料庫更新中']

      render_msg :text,  [message]
    end

    private

    def sync
      params.require(:sync) == 'true'
    end

    def out_of_range
      page >= (Product.count / 9.0).ceil
    end

    def products
      Product.available.category_scope(category).paginate(page, 9)
    end

    def page
      params.require(:page).to_i
    end

    def category
      params.require(:product).require(:category)
    end
  end
end
