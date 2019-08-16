module ChatfuelJson
  module UrlHelper
    def products_url(category, page = 1)
      query_string = "product[category]=#{category}&user[messenger_id]=#{messenger_id}&page=#{page}"
      "#{IsspayApi.config.API_URL}/api/chatfuel/products?#{query_string}"
    end

    def destroy_transaction_url(transaction)
      query_string = "user[messenger_id]=#{messenger_id}"
      "#{IsspayApi.config.API_URL}/api/chatfuel/delete_transaction/#{transaction.id}?#{query_string}"
    end

    def purchase_url(product)
      "#{IsspayApi.config.API_URL}/api/chatfuel/create_transaction?" + 
      "user[messenger_id]=#{messenger_id}&products[][id]=#{product.id}&products[][quantity]=1"
    end
  end
end