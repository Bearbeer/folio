class User < ActiveRecord::Base
  has_secure_password
  # deleted_at 기반 소프트 딜리트 기능 이용
  acts_as_paranoid

  self.table_name = :users

  validates :username, presence: { message: 'ID가 존재하지 않음' },
            uniqueness: { case_sensitive: false, message: 'ID가 중복됨' },
            format: {
                :with => /\A[a-z]+[a-z0-9]{5,11}\z/,
                :message => 'ID 정책 위반'
            }
  validates :password, presence: { message: '비밀번호가 존재하지 않음' },
            length: { minimum: 8, message: '비밀번호는 8자리 이상이여야 함' }
  validate :password_with_blank

  private

  def password_with_blank
    return if password.present? && !password.include?(' ')

    errors.add :password, '비밀번호에 공백문자 포함'
  end
end