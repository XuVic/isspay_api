class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def body(view)
    render("mails/#{view}")
  end
end
