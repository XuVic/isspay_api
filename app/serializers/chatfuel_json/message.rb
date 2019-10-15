module ChatfuelJson
  module Message
    def text(messages)
      messages.map do |msg|
        { text: msg }
      end
    end

    def receipt_reply(transaction)
      message = purchase_receipt(transaction) if transaction.purchase?
      message = transfer_receipt(transaction) if transaction.transfer?
      [ message ]
    end

    def out_of_stock
      text = "抱歉，沒有庫存了"
      replies = [ quick_reply('通知管理員') ]

      message = { text: text, quick_replies: replies }
      [ message ]
    end

    def check_account(fields)
      messages = []
      messages.concat consumption_message if fields.include?('consumption')
      messages.concat balance_message if fields.include?('balance')
      messages
    end

    private

    def purchase_receipt(transaction)
      text = "成功購買 #{transaction.product_names.join(';')}，" \
      "總金額為 #{transaction.amount} "
      replies = []
      replies << quick_reply('還要吃', url: products_url('snack'))
      replies << quick_reply('還要喝', url: products_url('drink'))
      replies << quick_reply('取消購買', url: destroy_transaction_url(transaction))

      { text: text, quick_replies: replies }
    end

    def transfer_receipt(transaction)
      text = "成功轉帳給 #{transaction.receiver_names.join(';')}，" \
      "總金額為 #{transaction.amount}"
      replies = [ quick_reply('取消轉帳', url: destroy_transaction_url(transaction)) ]
      { text: text, quick_replies: replies }
    end

    def balance_message
      [
        { text: "您的收入: #{@resources[0].credit}"},
        { text: "您的支出：#{@resources[0].debit}" },
        { text: "您的餘額為： #{@resources[0].balance}", 
          quick_replies: [ quick_reply('我要還款', url: repayment_url) ]
        }
      ]
    end

    def consumption_message
      records = @resources[0].consumption(2)
      records.map do |record|
        { text: "#{record[:date]}，共購買了#{record[:products]}產品，總花費#{record[:cost]}" }
      end
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