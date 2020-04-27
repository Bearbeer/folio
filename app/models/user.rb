# frozen_string_literal: true

# 회원 모델
class User < ActiveRecord::Base
  has_secure_password
  # deleted_at 기반 소프트 딜리트 기능 이용
  acts_as_paranoid

  self.table_name = :users

  validates :username,
            uniqueness: { case_sensitive: false, message: '값이 이미 존재합니다' },
            length: { in: 6..12, message: '는 6자리 이상 12자리 이하이어야 합니다' },
            format: {
              with: /\A[a-z]+[a-z0-9]{0,13}\z/,
              message: '은 영문 소문자로 시작하는 영문+숫자 조합이어야 합니다'
            }

  validate :validate_password

  private

  def validate_password
    if password.nil?
      errors.add(:password, '를 입력해주세요') if password_digest.blank?
      return
    end

    errors.add :password, '는 8자리 이상이어야 합니다' if password.length < 8
    errors.add :password, '에 공백문자가 포함되지 않아야 합니다' if password.include?(' ')
  end
end