#
# 회원 관련 기능을 관리하는 컨트롤러
class UserController < ApiController
  before_action :validate_authorization, only: [:unregister]

  def register
    raise Exceptions::BadRequest if request.headers['Authorization'].present?
    raise Exceptions::BadRequest unless user_params.has_key?(:username) and user_params.has_key?(:password)
    
    new_user = User.create(username: user_params[:username], password: user_params[:password])
    new_user.save!
    
    json(code: 200)
  
    # 아이디, 비밀번호 정책 위반
  rescue ActiveRecord::RecordInvalid
    raise Exceptions::BadRequest
  end

  def unregister
    @current_user.delete

    json(code: 200)
  end
  
  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end