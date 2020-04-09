class ApiController < ApplicationController

  rescue_from Exception do |e|
    internal_server_error(e)
  end

  rescue_from Exceptions::BadRequest, with: :bad_request
  rescue_from Exceptions::Unauthorized, with: :unauthorized
  rescue_from Exceptions::Forbidden, with: :forbidden
  rescue_from Exceptions::NotFound, with: :not_found
  rescue_from Exceptions::TooManyRequest, with: :too_many_requests
  rescue_from ActionController::ParameterMissing, with: :bad_request

  def json(**args)
    response.content_type = 'application/json'
    code = args[:code] || 200
    data = { code: code, data: args[:data], message: message_for_code(code) }.as_json

    render(json: data, status: code, callback: params[:callback])
  end

  protected

  def bad_request
    json code: 400
  end

  def unauthorized
    json code: 401
  end

  def forbidden
    json code: 403
  end

  def not_found
    json code: 404
  end

  def too_many_requests
    json code: 429
  end

  def internal_server_error(e)
    exception = "#{e.class.name} : #{e.message}"
    json(code: 500, data: { exception: exception })
  end

  private

  #
  # 200: 정상 요청
  # 400: 필수 요청 파라미터 누락 등 API 스펙 미준수
  # 401: http Token 누락 등 미인증 클라이언트
  # 403: 요청 가능한 회원이 아닌 등 권한 없음
  # 404: API 없음, 데이터 없음 등
  # 429: 지정된 시간 내 요청 가능 회수 초과
  def message_for_code(code)
    case code
    when 200 then :ok
    when 400 then :bad_request
    when 401 then :unauthorized
    when 403 then :forbidden
    when 404 then :not_found
    when 429 then :too_many_requests
    else :unknown
    end
  end
end