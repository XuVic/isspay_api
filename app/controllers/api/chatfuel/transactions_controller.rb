module Api::Chatfuel
  class TransactionsController < BaseController
    before_action :find_transaction, only: %i(destroy)

    def create
      transaction = CreateTransaction.new(user: current_user, params: transaction_params).call!
      current_user.reload_account
      replier.create(transaction, current_user.account)
    end

    def destroy
      authorize! :destroy, @transaction
      product_names = @transaction.product_names      
      DeleteTransaction.new(@transaction).call!
      current_user.reload_account
      replier.destroy(product_names, @transaction, current_user.account)
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
