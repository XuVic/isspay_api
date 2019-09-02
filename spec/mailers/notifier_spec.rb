require "rails_helper"

RSpec.describe NotifierMailer, type: :mailer do
  describe '#welcome' do
    let(:user) { create(:user) }
    let(:mail) { NotifierMailer.welcome(user) }

    it { expect(mail.to).to include(user.email) }
    it { binding.pry }
  end
end
