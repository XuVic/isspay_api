class NotifierMailer < ApplicationMailer
  default from: 'isspay.noreply@isspay.com'

  def confirmation(user_id, password)
    @user = find_user(user_id)
    @password = password
    @confirmation_url = "#{IsspayApi.config.API_URL}/api/v1/users/confirmation/#{@user.confirmation_token}"
    mail to: @user.email, subject: 'IssPay: Email Comfirmation', body: body('confirmation')
  end

  private

  def find_user(user_id)
    User.find(user_id)
  end
end
