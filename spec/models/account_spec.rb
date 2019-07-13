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

require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
