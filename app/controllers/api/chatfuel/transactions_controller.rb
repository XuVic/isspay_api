module Api::Chatfuel
  class TransactionsController < BaseController
    before_action :find_transaction, only: %i(destroy)

    def create
      transaction_form = TransactionForm.new(current_user, purchased_products)
      result = transaction_form.submit
      if resource?(result)
        message = ChatfuelJson::Response.new(resources: [result], messenger_id: messenger_id)
        message.body_to(:receipt_reply, result)
        render_json message
      end
    end

    def destroy
      authorize! :destroy, @transaction

      message = "取消購買 #{@transaction.product_names.join(';')} " \
                "退回 #{@transaction.amount}，目前餘額 #{current_user.balance}" 
      @transaction.destroy!

      message = ChatfuelJson::Response.new(messages: [message])
      message.body_to(:text)
      render_json message
    end

    private

    def purchased_products_params
      params.permit(products: [:id, :quantity])
    end

    def transaction_id
      params.permit(:id).require(:id)
    end

    def find_transaction
      @transaction = Transaction.find(transaction_id)
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
