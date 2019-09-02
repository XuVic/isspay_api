class MailerJob < ApplicationJob
  
  def perform(mailer_info)
    mailer_name, action, args = mailer_info.values
    deliver_mail(mailer_name, action, args)
  end

  private
  def deliver_mail(mailer_name, action, args)
    mailer(mailer_name).new.send(action.to_sym, *args).deliver
  end

  def mailer(mailer_name)
    "#{mailer_name}Mailer".constantize
  end
end