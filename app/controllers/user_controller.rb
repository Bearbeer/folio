# frozen_string_literal: true

# 회원가입/탈퇴 기능을 관리하는 컨트롤러
class UserController < ApiController
  include UserHelper
  include SessionHelper

  before_action :validate_authorization, only: :destroy

  def index
    user = User.find_by(id: current_user.id)
    json(data: { user: user_view(user)})
  end

  # POST /users
  def create
    validate_create_params
    validate_username

    # 필수 아닌 파라미터들
    params[:name] = '' unless params[:name].present?
    params[:email] = '' unless params[:email].present?
    params[:mobile] = '' unless params[:mobile].present?
    params[:birthday] = '' unless params[:birthday].present?
    params[:address] = '' unless params[:address].present?



    user = User.create!(username: params[:username],
                        password: params[:password],
                        gender: params[:gender],
                        name: params[:name],
                        mobile: params[:mobile],
                        email: params[:email],
                        birthday: params[:birthday],
                        address: params[:address])

    json(data: { user: user_view(user), session: session_view(user) })
  end

  # PUT /users
  def update
    validate_user_id
    raise Exceptions::BadRequest, '성별을 정확히 선택해주세요' unless params[:gender] == '남자' || params[:gender] == '여자' || nil

    user = User.find_by(id: current_user.id)

    params[:name] = current_user.name unless params[:name].present?
    params[:email] = current_user.email unless params[:email].present?
    params[:mobile] = current_user.mobile unless params[:mobile].present?
    params[:birthday] = current_user.birthday unless params[:birthday].present?
    params[:address] = current_user.address unless params[:address].present?


    user.update!(name: params[:name],
                email: params[:email],
                mobile: params[:mobile],
                gender: params[:gender],
                birthday: params[:birthday],
                address: params[:address])

    json(data: { user: user_view(user) })
  end

  # DELETE /users/:id
  def destroy
    validate_user_id
    user = User.find_by(id: current_user.id)
    user.destroy

    json(code: 200, message: '회원탈퇴가 완료되었습니다')
  end

  private

  def validate_create_params
    params.require(:username)
    params.require(:password)

    raise Exceptions::BadRequest, '성별을 정확히 선택해주세요' unless params[:gender] == '남자' || params[:gender] == '여자' || params[:gender] == nil
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