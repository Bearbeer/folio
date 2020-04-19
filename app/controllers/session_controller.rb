# frozen_string_literal: true

# 로그인 기능을 관리하는 컨트롤러
class SessionController < ApiController
  EXPIRES_AT = 1.day.from_now

  # POST /sessions
  def create
    validate_params

    user = User.find_by(username: params[:username].downcase)
    unless user&.authenticate(params[:password])
      raise Exceptions::NotFound, '아이디와 비밀번호를 다시 확인하세요.'
    end

    json(code: 200, data: { token: token(user), expires_at: EXPIRES_AT })
  end

  private

  def validate_params
    params.require(:username)
    params.require(:password)
  end

  def token(user)
    JWT.encode({ user_id: user.id, exp: EXPIRES_AT.to_i }, ENV['SECRET_KEY_BASE'])
  end
end