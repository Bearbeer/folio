# frozen_string_literal: true

# 로그인 기능을 관리하는 컨트롤러
class SessionController < ApiController
  include UserHelper
  include SessionHelper

  # POST /sessions
  def create
    validate_params

    user = User.find_by(username: params[:username].downcase)
    unless user&.authenticate(params[:password])
      raise Exceptions::NotFound, '아이디와 비밀번호를 다시 확인하세요.'
    end

    json(data: { user: user_view(user), session: session_view(user) })
  end

  private

  def validate_params
    params.require(:username)
    params.require(:password)
  end
end