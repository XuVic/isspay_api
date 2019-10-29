module ChatfuelJson
  module UrlHelper
    def products_url(category, page = 1)
      query_string = "product[category]=#{category}&user[messenger_id]=#{messenger_id}&page=#{page}"
      "#{chatfuel_url}/products?#{query_string}"
    end

    def destroy_transaction_url(transaction)
      query_string = "user[messenger_id]=#{messenger_id}"
      "#{chatfuel_url}/delete_transaction/#{transaction.id}?#{query_string}"
    end

    def purchase_url(product)
      "#{chatfuel_url}/api/chatfuel/create_transaction?" \
      "user[messenger_id]=#{messenger_id}&products[][id]=#{product.id}&products[][quantity]=1"
    end

    def repayment_url
      "#{chatfuel_url}/repayment/#{messenger_id}"
    end

    def cancel_product_url(product)
      "#{chatfuel_url}/delete_product/#{product.id}?#{messenger_id}"
    end

    private

    def messenger_id
      "user[messenger_id]=#{messenger_id}"
    end

    def chatfuel_url
      "#{IsspayApi.config.API_URL}/api/chatfuel"
    end
  end
end