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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable

  has_one :account, foreign_key: 'owner_id', dependent: :destroy

  accepts_nested_attributes_for :account

  enum gender: %i[male female]
  enum role: %i[master phd candidate staff alumni]

  delegate :credit, :debit, :balance, :orders, :transfers, :transactions, to: :account

  default_scope { includes(:account) }

  before_create do
    skip_confirmation_notification!
  end

  after_create do
    create_account
  end

  def self.find_by_messenger_id(messenger_id)
    where(messenger_id: messenger_id).first!
  end

  def self.authenticate(email:, password: )
    user_obj = where(email: email).first

    if user_obj
      user_obj = nil unless user_obj.valid_password?(password)
    end

    user_obj
  end

  def credit=(amount)
    self.account.credit = amount
  end

  def set_admin!(is_admin)
    self.admin = is_admin
    self.save!
  end

  def name
    "#{last_name} #{first_name}"
  end
end
