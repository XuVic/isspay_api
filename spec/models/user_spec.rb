# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  role                   :integer          default("master"), not null
#  gender                 :integer          default("male"), not null
#  nick_name              :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  messenger_id           :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  # it 'debugging' do
  #   binding.pry
  # end

  describe 'Referential Integrity' do
    context 'when user is created' do
      it 'account is referenced to user' do
        expect(user.id).to eq(user.account.owner_id)
      end
    end

    context 'when user is destroyed' do
      it 'account is destroyed also' do
        account_id = user.account.id
        user.destroy
        expect { Account.find(account_id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'Domain Integrity:' do
    subject(:not_null) { ActiveRecord::NotNullViolation }

    def self.not_null_violiation(attribute)
      context "when #{attribute.keys[0]} is nil" do
        it { expect { create(:user, attribute) }.to raise_error(not_null) }
      end
    end

    not_null_violiation(role: nil)
    not_null_violiation(gender: nil)

    subject(:record_invalid) { ActiveRecord::RecordInvalid }
    context 'when email is empty' do
      it { expect { create(:user, email: '') }.to raise_error(record_invalid) }
    end

    context 'when password is empty' do
      it { expect { create(:user, password: '') }.to raise_error(record_invalid) }
    end
  end

  describe '#admin?' do
    context 'creata an admin account' do
      it { expect(admin.admin?).to be true }
    end
  end

  describe '#valid_password?' do
    context 'when password is correct' do
      it { expect(user.valid_password?('abcd1234')).to be true }
    end

    context 'when password is wrong' do
      it { expect(user.valid_password?('wrong_password')).to be false }
    end
  end
end
