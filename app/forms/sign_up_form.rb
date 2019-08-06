class SignUpForm < BaseForm
  delegate :email, to: :resource 

  validates :email, presence: true, uniqueness: true
end