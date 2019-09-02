class NotifierMailer < ApplicationMailer
  default from: 'isspay.noreply@isspay.com'

  def welcome(user_id)
    @user = find_user(user_id)
    mail to: @user.email, subject: 'Welcome to use IssPay', body: body('welcome')
  end

  private

  def find_user(user_id)
    User.find(user_id)
  end
end
