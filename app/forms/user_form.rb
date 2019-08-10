class UserForm < BaseForm
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  delegate :email, :password, :password_confirmation, :role, :gender, :first_name, :last_name, to: :resource 

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX
  validates :password, presence: true, confirmation: true, if: :sign_up?
  validates :password_confirmation, presence: true, if: :sign_up?
  validates :role, presence: true
  validates :gender, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def sign_up?
    context == :sign_up
  end
end