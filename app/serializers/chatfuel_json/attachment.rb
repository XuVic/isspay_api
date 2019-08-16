module ChatfuelJson
  module Attachment
    def products_gallery(page)
      product_elements = resources.map do |resource|
        {
          title: resource.name,
          image_url: resource.image_url,
          subtitle: "價格: #{resource.price}; 數量#{resource.quantity}",
          buttons: [button('json_plugin_url', '購買', purchase_url(resource))]
        }
      end
      
      if page[0]
        product_elements << {
          title: "目前在第 #{page[0] - 1} 頁",
          image_url: 'https://i.imgur.com/T0TMWEr.png',
          subtitle: "總共 #{Product.count} 個產品; #{(Product.count / 9.0).ceil} 頁",
          buttons: [button('json_plugin_url', '下一頁', products_url(resources[0].category_name, page[0]))]
        }
      end

      payload_content = payload(product_elements, 'gallery')
      [ to_attachments(payload_content) ]
    end

    def co

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