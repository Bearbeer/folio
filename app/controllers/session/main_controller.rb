module Session
  #
  # 로그인, 로그아웃 기능을 관리하는 컨트롤러
  class MainController < ApiController
    before_action :validate_authorization, only: [:logout]

    def login
      raise Exceptions::BadRequest if request.headers['Authorization'].present?

      user_params = params.permit(:username, :password)
      raise Exceptions::BadRequest unless user_params.permitted? and user_params.has_key?(:username) and user_params.has_key?(:password)

      user = User.find_by(username: user_params[:username].downcase)
      raise Exceptions::NotFound unless user and user.authenticate(user_params[:password])

      json(code: 200, data: { token: session_token(user) })
    end

    def logout
      json(code: 204)
    end

    private

    def session_token(user)
      JWT.encode({ user_id: user.id, exp: 30.days.from_now.to_i }, ENV['SECRET_KEY_BASE'])
    end
  end
end