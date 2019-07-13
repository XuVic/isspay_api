# == Schema Information
#
# Table name: transfer_details
#
#  transaction_id :uuid
#  receiver_id    :uuid
#  amount         :float            not null
#

class TransferDetail < ApplicationRecord
  belongs_to :transfer, foreign_key: :transaction_id, class_name: 'Transaction'
  belongs_to :receiver, class_name: 'Account'
end
