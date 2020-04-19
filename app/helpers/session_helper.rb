# frozen_string_literal: true

# 세션 헬퍼
module SessionHelper
  EXPIRES_AT = 1.day.from_now

  def session_view(user)
    {
      token: token(user),
      expires_at: EXPIRES_AT
    }
  end

  private

  def token(user)
    JWT.encode({ user_id: user.id, exp: EXPIRES_AT.to_i }, ENV['SECRET_KEY_BASE'])
  end
end