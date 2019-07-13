# == Schema Information
#
# Table name: accounts
#
#  id         :uuid             not null, primary key
#  debit      :float            default(0.0), not null
#  credit     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :uuid
#

class Account < ApplicationRecord
  belongs_to :owner, foreign_key: 'owner_id', class_name: 'User'
  has_many :transactions
  has_many :transfer_details, foreign_key: :receiver_id
  has_many :transfers, through: :transfer_details
end
