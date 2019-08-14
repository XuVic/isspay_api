module ChatfuelJson
  module Attachment
    def products_gallery
      product_elements = resources.map do |resource|
        
        {
          title: resource.name,
          image_url: resource.image_url,
          subtitle: "價格: #{resource.price}; 數量#{resource.quantity}",
          buttons: [button('json_plugin_url', '購買', purchase_url(resource))]
        }
      end
      payload_content = payload(product_elements, 'gallery')
      [ to_attachments(payload_content) ]
    end

    def purchase_url(product)
      "#{IsspayApi.config.API_URL}/api/chatfuel/create_transaction?" + 
      "user[messenger_id]=#{messenger_id}&products[][id]=#{product.id}&products[][quantity]=1"
    end

    private

    def button(type, title, url)
      {
        type: type,
        title: title,
        url: url
      }
    end

    def payload(elements, type)
      Payload.new(elements, type)
    end

    def to_attachments(payload_content)
      {
        attachment: {
          type: 'template',
          payload: payload_content.serializable
        }
      }
    end
  end
end