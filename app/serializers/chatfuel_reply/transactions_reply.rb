module ChatfuelReply
  class TransactionsReply < Reply
    def create(transaction)
      message = purchase_receipt(transaction) if transaction.purchase?
      message = transfer_receipt(transaction) if transaction.transfer?
      set_reply_body [ message ]
    end

    def destroy(product_names, transaction, account)
      messages = [
        "成功取消購買 #{product_names.join(';')}",
        "退回#{transaction.amount}",
        "目前花費 #{-1 * account.balance}"
      ]
      send_messages(messages)
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
  end
end