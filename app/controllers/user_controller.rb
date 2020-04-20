
# 유저관련 기능을 관리하는 컨트롤러
class UserController < ApiController
  #before_action :validate_authorization, only: [:logout]
  #before_action :validate_authorization, only: [:logout]


  def register
    unless user_params[:username] & user_params[:password]
    end

    user = User.create!(username: user_params[:username], password: user_params[:password])

    # 회원가입하면 자동로그인 해주나요?
    json(code: 200, user: user)

  end

  def drop_out
    user = User.find_by(username: user_params[:username])

    raise Exceptions::NotFound unless user
              
    user.delete
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
    json(code: 200)
  end
end