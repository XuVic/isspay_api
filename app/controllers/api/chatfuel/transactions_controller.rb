module Api::Chatfuel
  class TransactionsController < BaseController
    before_action :find_transaction, only: %i(destroy)

    def create
      transaction = CreateTransaction.new(current_user, transaction_params).call!
      message = ChatfuelJson::Serializer.new(messenger_id)
      message.set_msg_body(:receipt_reply, transaction)
      respond_with message
    end

    def destroy
      authorize! :destroy, @transaction

      message = "取消購買 #{@transaction.product_names.join(';')} " \
                "退回 #{@transaction.amount}，目前餘額 #{current_user.balance}" 
      
      @transaction.destroy!

      message = ChatfuelJson::Serializer.new(messenger_id)
      message.set_msg_body(:text, [message])
      render_json message
    end

    private

    def genre
      params.require(:transaction).require(:genre)
    end

    def transaction_id
      params.require(:id)
    end

    def find_transaction
      @transaction = Transaction.find(transaction_id)
    end

    def transaction_params
      sanitize_transaction_params
      params.require(:transaction).permit(:genre, purchased_products_attributes: [:product_id, :quantity], transfer_details_attributes: [:receiver_id, :amount])
    end
  
    def sanitize_transaction_params
      if params[:transaction][:purchased_products_attributes]
        params[:transaction][:purchased_products_attributes].each do |purchase_param|
          purchase_param[:quantity] = purchase_param[:quantity].to_i
        end
      end
  
      if params[:transaction][:transfer_details_attributes]
        params[:transaction][:transfer_details_attributes].each do |transfer_params|
          transfer_params[:amount] = transfer_params[:amount].to_i
        end
      end
    end
  end
end
