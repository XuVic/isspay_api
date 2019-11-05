module ChatfuelReply
  class AccountsReply < Reply
    def show(account)
      purchased_date = account.orders.unpaid.first.created_at
      last_date = account.orders.unpaid.last.created_at.strftime('%Y/%m/%d')
      products_count = account.purchased_products(unpaid: true).map(&:quantity).sum
      total_amount = account.orders.unpaid.map(&:amount).sum
      messages = [
        { text: "最後一次消費時間為 #{purchased_date}" },
        { text: "從#{last_date}，總共購買了#{products_count}商品" },
        { text: "總共還款金額為： #{total_amount}", 
          quick_replies: [ quick_reply('我要還款', url: repayment_url) ]
        }
      ]
      set_reply_body messages
    end

    private

    def account
      user.account
    end
  end
end