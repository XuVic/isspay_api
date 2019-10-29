module ChatfuelJson
  module Attachment
    def products_gallery(products, page)
      product_elements = products.map do |product|
        {
          title: product.name,
          image_url: product.image_url,
          subtitle: "價格: #{product.price}; 數量#{product.quantity}",
          buttons: [button('json_plugin_url', '購買', purchase_url(product))]
        }
      end

      category = products[0].category
      products_count = Product.category_scope(category.to_s).available.count

      product_elements << {
        title: "目前在第 #{page} 頁",
        image_url: 'https://i.imgur.com/T0TMWEr.png',
        subtitle: "總共 #{products_count} 個#{category}; 共 #{(products_count / 9.0).ceil} 頁",
        buttons: [button('json_plugin_url', '下一頁', products_url(category, page+1))]
      }

      payload_content = payload(product_elements, 'gallery')
      [ to_attachments(payload_content) ]
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