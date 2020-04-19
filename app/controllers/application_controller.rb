# frozen_string_literal: true

# 컨트롤러 전체 공통 기능 관리
class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_reader :current_user

  protected

  def validate_authorization
    unless user_id_in_token?
      render_401_error
      return false
    end

    @current_user = User.find(decoded_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render_401_error
  end

  private

  def user_id_in_token?
    http_token && decoded_token && !decoded_token[:user_id].to_i.zero?
  end

  def http_token
    auth = request.headers['Authorization']
    @http_token ||= auth.split(' ').last if auth.present?
  end

  def decoded_token
    @decoded_token ||= JsonWebToken.decode(http_token)
  end

  def render_401_error
    render json: { errors: ['Not Authorized'] }, status: :unauthorized
  end
end
