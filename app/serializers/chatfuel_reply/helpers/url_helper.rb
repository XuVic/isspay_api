module ChatfuelReply
  module Helpers::UrlHelper
    def products_url(category, page = 1)
      query_string = "product[category]=#{category}&#{messenger_id_str}&page=#{page}"
      "#{chatfuel_url}/products?#{query_string}"
    end

    def destroy_transaction_url(transaction)
      "#{chatfuel_url}/delete_transaction/#{transaction.id}?#{messenger_id_str}"
    end

    def purchase_url(product)
      "#{chatfuel_url}/create_transaction?" \
      "#{messenger_id_str}&transaction[purchased_products_attributes][][product_id]=#{product.id}&transaction[purchased_products_attributes][][quantity]=1&transaction[genre]=purchase"
    end

    def repayment_url
      "#{chatfuel_url}/account/repay?#{messenger_id_str}"
    end

    def cancel_product_url(product)
      "#{chatfuel_url}/delete_product/#{product.id}?#{messenger_id}"
    end

    private

    def messenger_id_str
      "user[messenger_id]=#{messenger_id}"
    end

    def chatfuel_url
      "#{IsspayApi.config.API_URL}/api/chatfuel"
    end
  end
end