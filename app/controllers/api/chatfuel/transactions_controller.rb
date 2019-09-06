module Api::Chatfuel
  class TransactionsController < BaseController
    prepend_before_action :sanitize_params, only: :create
    before_action :find_transaction, only: %i(destroy)


    def create
      result = CreateTransaction.new(current_user, create_form).call

      if result.success?
        message = ChatfuelJson::Response.new(resources: [result.body], messenger_id: messenger_id)
        message.body_to(:receipt_reply, result.body)
        respond_with message
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

    def genre
      params.require(:transaction).require(:genre)
    end
  
    def create_form
      if genre == 'purchase'
        TransactionForm.purchase_products(current_user, purchase_params)
      elsif genre == 'transfer'
        TransactionForm.transfer_money(current_user, transfer_params)
      end
    end

    def sanitize_purchase_params
      params[:purchases].each do |params|
        params[:quantity] = params[:quantity].to_i
        params
      end
    end

    def purchase_params
      sanitize_purchase_params
      params.permit(purchases: [:product_id, :quantity]).require(:purchases)
    end

    def transaction_id
      params.require(:id)
    end

    def find_transaction
      @transaction = Transaction.find(transaction_id)
    end

    def transfer_params
      santiize_transfer_params
      params.permit(transfers: [:receiver_id, :amount]).require(:transfers)
    end
  
    def santiize_transfer_params
      params[:transfers].each do |params|
        params[:amount] = params[:amount].to_i
        params
      end
    end
  end
end
