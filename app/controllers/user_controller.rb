#
# 회원 관련 기능을 관리하는 컨트롤러
class UserController < ApiController
  before_action :validate_authorization, only: [:withdraw]

  # 질문 있음
  def register
    raise Exceptions::BadRequest unless user_params.has_key?(:username) and user_params.has_key?(:password)
    
    user = User.create(username: user_params[:username], password: user_params[:password])
    user.save!
    
    json(code: 200, data: { username: user.username })
  
  rescue ActiveRecord::RecordInvalid
    raise Exceptions::BadRequest
  end

  def withdraw
    user = User.find(params[:id])
    user.delete

    json(code: 200)
  end
  
  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end