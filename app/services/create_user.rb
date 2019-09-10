class CreateUser < BaseService
  attr_reader :params

  def initialize(params)
    @params = params
    super
  end

  def call
    create_temp_password
    create_user
    send_confirmation_mail

    super
  rescue ServiceHalt
    @result
  end

  private

  def create_temp_password
    unless params['email']
      @result = Result.new(status: 400, body: 'Email cannot be blank.')
      raise ServiceHalt
    end

    temp_pwd = Base64.strict_encode64(params['email'])
    params['password'] = temp_pwd
    params['password_confirmation'] = temp_pwd
    data[:password] = params['password']
    data[:form] = UserForm.in_create(User.new(params))
  end

  def create_user
    @result = data[:form].submit
    raise ServiceHalt if @result.failure?
    
    data[:args] = [@result.body.id, data[:password]]
  end

  def send_confirmation_mail
    MailerJob.perform_later({ mailer: 'Notifier', action: 'confirmation', args: data[:args] })
  rescue error
    @result = Result.new(status: 404, body: error.message)
  end
end