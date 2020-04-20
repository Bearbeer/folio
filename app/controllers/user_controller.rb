
# 유저관련 기능을 관리하는 컨트롤러
class UserController < ApiController
  #before_action :validate_authorization, only: [:logout]
  #before_action :validate_authorization, only: [:logout]


  def register

    unless params[:username] and params[:password]
      raise Exceptions::NotFound
    end

    user = User.create!(username: params[:username], password: params[:password])

    # 회원가입하면 자동로그인 해주나요?
    json(code: 200, data: user)

  end

  def drop_out
    # 로그인 확인 필요 param 대신 현재 유저
    user = User.find_by(username: params[:username])

    raise Exceptions::NotFound unless user
              
    user.delete
    json(code: 200)
  end
  
end