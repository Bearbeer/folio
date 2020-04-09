module Session
  #
  # 로그인, 로그아웃 기능을 관리하는 컨트롤러
  class MainController < ApiController
    before_action :validate_authorization, only: [:logout]

    def login
      user = User.find_by(username: user_params[:username].downcase)
      raise Exceptions::NotFound unless user
      raise Exceptions::Unauthorized unless user.authenticate(user_params[:password])

      json(code: 200, data: { token: session_token(user) })
    end

    def logout

    end

    private

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def session_token(user)
      JWT.encode({ user_id: user.id, exp: 30.days.from_now.to_i }, ENV['SECRET_KY_BASE'])
    end
  end
end