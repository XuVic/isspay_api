module ChatfuelReply
  class UsersReply < Reply
    def update(user)
      messages = ["更新後的資訊 - "]
      messages += user_info(user)

      set_reply_body text(messages)
    end

    def show(user)
      messages = ["#{user.name} 你好，以下是你的帳號資訊 - "]
      messages += user_info(user)

      set_reply_body text(messages)
    end

    private

    def user_info(user)
      [
        "ID: #{user.id}",
        "Email: #{user.email}",
        "Role: #{user.role}",
        "Name: #{user.name}",
        "Account Balance: #{user.balance}"
      ]
    end
  end
end