class UserForm < Form
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  

  delegate :email, :password, :password_confirmation, :role, :gender, :first_name, :last_name, :messenger_id,
           to: :target_resource

  def self.in_create(resource, options = {})
    validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX
    validates :password, presence: true, confirmation: true
    validates :password_confirmation, presence: true
    validates :role, presence: true
    validates :gender, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :messenger_id, uniqueness: true
    super(resource, options)
  end
end