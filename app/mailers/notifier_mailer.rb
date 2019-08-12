class NotifierMailer < ApplicationMailer
  default from: 'isspay.noreply@isspay.com'
  
  def test
    @message = 'test'
    @test = 'test2'
    mail to: 'xumingyo@gmail.com', subject: 'hello', body: body('test')
  end
end
