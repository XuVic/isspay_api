module ChatfuelJson
  module UrlHelper
    def products_url(category)
      query_string = "product[category]=#{category}&user[messenger_id]=#{messenger_id}"
      "#{IsspayApi.config.API_URL}/api/chatfuel/products?#{query_string}"
    end

    def destroy_transaction_url(transaction)
      query_string = "user[messenger_id]=#{messenger_id}"
      "#{IsspayApi.config.API_URL}/api/chatfuel/delete_transaction/#{transaction.id}?#{query_string}"
    end
  end
end