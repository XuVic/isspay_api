module Api::Chatfuel
  class TransactionsController < BaseController
    def create
      transaction_form = TransactionForm.new(current_user, purchased_products)
      result = transaction_form.submit
      if resource?(result)
        message = ChatfuelJson::Response.new(resources: [result], messenger_id: messenger_id)
        message.body_to(:receipt_reply)
        render_json message
      end
    end

    def destroy
    end

    private

    def purchased_products_params
      params.permit(products: [:id, :quantity])
    end
  
    def sanitize_params
      params[:products].each do |params|
        params[:quantity] = params[:quantity].to_i
        params
      end
    end
  
    def purchased_products
      purchased_products_params[:products].inject([]) do |products, params|
        temp = params[:quantity].times.map { Product.find(params[:id]) }
        products += temp
      end
    end
  end
end
