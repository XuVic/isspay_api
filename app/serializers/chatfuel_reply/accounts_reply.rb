module ChatfuelReply
  class AccountsReply < Reply
    def show(account)
      messages = nil
      if account.orders.unpaid.exists?
        messages = has_unpaid(account)
      else
        replies = []
        replies << quick_reply('來點吃的', url: products_url('snack'))
        replies << quick_reply('來點喝的', url: products_url('drink'))
        messages = [
          {
            text: "沒有欠款，目前帳戶餘額 #{account.balance}",
            quick_replies: replies
          }
        ]

      end
      set_reply_body messages
    end

    def repay(balance, account)
      first_date = account.orders.paid.first.created_at.strftime('%Y/%m/%d')
      messages = [
        "總共償還金額為 #{-1 * balance}",
        "目前帳戶欠款#{account.balance}",
        "最後交易時間為 #{first_date}"
      ]
      send_messages messages
    end

    private

    def has_unpaid(account)
      purchased_date = account.orders.unpaid.first.created_at
      last_date = account.orders.unpaid.last.created_at.strftime('%Y/%m/%d')
      products_count = account.purchased_products(unpaid: true).map(&:quantity).sum
      total_amount = account.orders.unpaid.map(&:amount).sum
      [
        { text: "最後一次消費時間為 #{purchased_date}" },
        { text: "從#{last_date}，總共購買了#{products_count}商品" },
        { text: "總共還款金額為： #{total_amount}", 
          quick_replies: [ quick_reply('我要還款', url: repayment_url) ]
        }
      ]
    end

    def account
      user.account
    end
  end
end