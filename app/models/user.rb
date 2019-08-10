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
#  messenger_id           :string           not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account, foreign_key: 'owner_id', dependent: :destroy

  enum gender: %i[male female]
  enum role: %i[master phd prof staff alumni admin]

  delegate :credit, :debit, :balance, to: :account

  after_create do
    create_account
  end

  def self.authenticate(email:, password: )
    user_obj = where(email: email).first

    if user_obj
      user_obj = nil unless user_obj.valid_password?(password)
    end

    user_obj
  end

  def admin?
    role == 'admin'
  end
end
