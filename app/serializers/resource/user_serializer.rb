module Resource
  class UserSerializer < BaseSerializer
    attributes :email, :nick_name, :gender, :role, :credit, :debit, :balance
  end
end