# frozen_string_literal: true

# 컨트롤러 전체 공통 기능 관리
class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_accessor :current_user

  protected

  def validate_authorization
    return if user_id_in_token? && current_user

    render_401_error
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

  def current_user
    @current_user ||= User.find_by(id: decoded_token[:user_id])
  end

  def render_401_error
    render json: { errors: ['Not Authorized'] }, status: :unauthorized
  end
end
