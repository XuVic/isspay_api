module ChatfuelReply
  class ProductsReply < Reply
    def index(products, page)
      if products.exists?
        image_elements = products_element(products) + [next_page_element(products, page)]
        payload = Attachment::Payload.new('gallery', image_elements)
        set_reply_body [ Attachment.to_h(payload) ]
      else
        set_reply_body out_of_stock
      end
    end

    private

    def out_of_stock
      text = "抱歉，沒有庫存了"
      replies = [ quick_reply('通知管理員') ]
      message = { text: text, quick_replies: replies }
      [ message ]
    end

    def products_element(products)
      products.map do |product|
        subtitle = "價格: #{product.price}; 數量#{product.quantity}"
        buttons = [Attachment::Button.new('json_plugin_url', '購買', purchase_url(product))]
        Attachment::ImageElement.new(product.name, product.image_url, subtitle, buttons)
      end
    end

    def next_page_element(products, page)
      category = products[0].category
      products_count = Product.category_scope(category.to_s).available.count
      subtitle = "總共 #{products_count} 個#{category}; 共 #{(products_count / 9.0).ceil} 頁"
      buttons = [Attachment::Button.new('json_plugin_url', '下一頁', products_url(category, page+1))]
      Attachment::ImageElement.new("目前在第 #{page} 頁", 'https://i.imgur.com/T0TMWEr.png', subtitle, buttons)
    end
  end
end