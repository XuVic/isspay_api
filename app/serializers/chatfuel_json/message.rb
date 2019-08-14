module ChatfuelJson
  module Message
    def texting
      messages.map do |msg|
        { text: msg }
      end
    end

    def receipt_reply
      text = "成功購買 #{resources[0].product_names.join(';')}，" \
            "總金額為 #{resources[0].amount} "
      replies = []
      replies << quick_reply('還要吃', url: products_url('snack'))
      replies << quick_reply('還要喝', url: products_url('drink'))
      replies << quick_reply('取消購買', url: 'test')

      message = { text: text, quick_replies: replies }
      [ message ]
    end

    def out_of_stock
      text = "抱歉，沒有庫存了"
      replies = [ quick_reply('通知管理員') ]

      message = { text: text, quick_replies: replies }
      [ message ]
    end

    private

    def products_url(category)
      query_string = "product[category]=#{category}&user[messenger_id]=#{messenger_id}"
      "#{IsspayApi.config.API_URL}/api/chatfuel/products?#{query_string}"
    end

    def quick_reply(title, options = {})
      type = options[:type] || 'json_plugin_url'
      reply = { title: title }
      reply.merge!(block_names: options[:block_names]) if options[:block_names]
      reply.merge!(url: options[:url]) if options[:url]
      reply.merge!(type: type) if options[:url]
      reply
    end
  end
end