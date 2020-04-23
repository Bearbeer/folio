# frozen_string_literal: true

# 회원가입/탈퇴 기능을 관리하는 컨트롤러
class UserController < ApiController
  include UserHelper
  include SessionHelper

  before_action :validate_authorization, only: :destroy

  # POST /users
  def create
    validate_create_params
    validate_username
    user = User.create!(username: params[:username], password: params[:password])

    json(data: { user: user_view(user), session: session_view(user) })
  end

  # DELETE /users/:id
  def destroy
    validate_user_id
    current_user.destroy

    json(code: 200, message: '회원탈퇴가 완료되었습니다')
  end

  private

  def validate_create_params
    params.require(:username)
    params.require(:password)
  end

  def validate_username
    return unless User.exists?(username: params[:username].downcase)

    raise Exceptions::Conflict, '이미 존재하는 아이디입니다'
  end

  def validate_user_id
    params.require(:id)
    return if current_user.id.to_i == params[:id].to_i

    raise Exceptions::Forbidden, '권한이 없습니다'
  end
end