class CreateUser < Service

  def call!
    create_temp_pwd
    validate_input
    confirme_user
    send_confirmation_mail
  end

  private

  def create_temp_pwd
    if params[:password].blank? && params[:email].present?
      temp_pwd = Base64.strict_encode64(params[:email])
      params[:password] = temp_pwd
      params[:password_confirmation] = temp_pwd
    end
  end

  def validate_input
    form = UserForm.in_create(User.new(params))
    data[:record] = form.submit!
    raise ServiceError unless data[:record].persisted?
    data[:args] = [Marshal.dump(data[:record]), params[:password]]
  end

  def confirme_user
    data[:record].confirm
    raise ServiceError.new('User is not confirmed') unless data[:record].confirmed?
  end

  def send_confirmation_mail
    MailerJob.perform_later(mailer: 'Notifier', action: 'confirmation', args: data[:args])
    data[:record]
  end
end