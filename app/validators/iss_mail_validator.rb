class IssMailValidator < ActiveModel::Validator
  VALID_ISS_EMAIL = /@iss.nthu.edu.tw/

  def validate(record)
    unless match_iss(record.email)
      record.errors.add(:email, :invalid, message: 'is not ISS mail.')
    end
  end

  private

  def match_iss(email)
    !!email.match(VALID_ISS_EMAIL)  
  end
end