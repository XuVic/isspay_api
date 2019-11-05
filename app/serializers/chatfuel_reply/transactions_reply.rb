module ChatfuelReply
  class TransactionsReply < Reply
    def create(transaction, account)
      message = purchase_receipt(transaction, account) if transaction.purchase?
      message = transfer_receipt(transaction, account) if transaction.transfer?
      set_reply_body [ message ]
    end

    def destroy(product_names, transaction, account)
      replies = []
      replies << quick_reply('還要吃', url: products_url('snack'))
      replies << quick_reply('還要喝', url: products_url('drink'))
      messages = [
        { text: "成功取消購買 #{product_names}" },
        { text: "退回#{transaction.amount}" },
        { text: "目前花費 #{-1 * account.balance}", quick_replies: replies }
      ]
      set_reply_body messages
    end

    private

    def purchase_receipt(transaction, account)
      text = "成功購買 #{transaction.product_names}，" \
      "總金額為 #{transaction.amount}，目前花費 #{-1 * account.balance} "
      replies = []
      replies << quick_reply('還要吃', url: products_url('snack'))
      replies << quick_reply('還要喝', url: products_url('drink'))
      replies << quick_reply('取消購買', url: destroy_transaction_url(transaction))

      { text: text, quick_replies: replies }
    end

    def transfer_receipt(transaction, account)
      text = "成功轉帳給 #{transaction.receiver_names}，" \
      "總金額為 #{transaction.amount}"
      replies = [ quick_reply('取消轉帳', url: destroy_transaction_url(transaction)) ]
      { text: text, quick_replies: replies }
    end
  end
end