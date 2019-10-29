module ChatfuelJson
  class AccountsReply < Reply
    def show
      messages = [
        { text: "您的餘額為： #{account.balance}", 
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