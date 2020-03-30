require 'bcrypt'

class User < ActiveRecord::Base

  self.table_name = :users

    # has_many :portfolio

  before_validation :validate_password, :set_password

  validates :username, presence: { message: 'ID가 존재하지 않음' },
            uniqueness: { case_sensitive: false, message: 'ID가 중복됨' },
            format: {
                :with => /\A[a-z]+[a-z0-9]{5,11}\z/,
                :message => 'ID 정책 위반'
            }
  validates :password, presence: { message: '비밀번호가 존재하지 않음' }

  private

  def validate_password
    return if password.present? && password.length >= 8 && !password.include?(' ')

    raise '비밀번호 정책 위반'
  end

  def set_password
    self.password = BCrypt::Password.create(password, cost: 10).to_s
  end
end