# frozen_string_literal: true

# 회원가입/탈퇴 기능을 관리하는 컨트롤러
class UserController < ApiController
  include UserHelper
  include SessionHelper

  before_action :validate_authorization, except: :create

  # POST /users
  def create
    attributes = prepare_create_params
    user = User.create!(attributes)

    json(data: { user: user_view(user), session: session_view(user) })
  end

  # POST /users/profile
  def profile
    json(data: { user: user_view(current_user) })
  end

  # PUT /users/:id
  def update
    attributes = prepare_update_params
    current_user.update!(attributes)

    json(data: { user: user_view(current_user) })
  end

  # DELETE /users/:id
  def destroy
    validate_user_id
    current_user.destroy

    json(code: 200, message: '회원탈퇴가 완료되었습니다')
  end

  private

  def validate_username
    return unless User.exists?(username: params[:username].downcase)

    raise Exceptions::Conflict, '이미 존재하는 아이디입니다'
  end

  def validate_user_id
    params.require(:id)
    return if current_user.id.to_i == params[:id].to_i

    raise Exceptions::Forbidden, '권한이 없습니다'
  end

  def validate_gender
    return if params[:gender].in?(User::GENDER) || params[:gender].nil?

    raise Exceptions::BadRequest, '성별을 정확히 선택해주세요'
  end

  def validate_create_params
    params.require(:username)
    params.require(:password)
    validate_username
    validate_gender
  end

  def prepare_create_params
    validate_create_params

    params.permit(:username, :password, :gender, :name, :email, :mobile, :birthday, :address)
          .to_h.compact
  end

  def validate_update_params
    validate_user_id
    validate_gender
  end

  def prepare_update_params
    validate_update_params

    params.permit(:gender, :name, :email, :mobile, :birthday, :address)
          .to_h.compact
  end

end