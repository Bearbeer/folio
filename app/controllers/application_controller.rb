class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :initialize_params
  skip_before_action :verify_authenticity_token

  attr_reader :current_user

  protected

  def validate_authorization
    render_401_error and return false unless user_id_in_token?

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

  def initialize_params
    @params = {}

    params&.each { |key, value| params_to_hash(@params, key, value) }
  end

  def params_to_hash(hash, key, value)
    if value.class == NilClass
      nil
    elsif value.class == String
      hash[key] = Rails.application.config.filter_parameters.map(&:to_s).include?(key) ? "*" * value.length : value
    elsif value.class == Array
      hash[key] = Array.new
      value.each { |arr| hash[key] << arr }
    elsif value.class == Hash || value.class == ActiveSupport::HashWithIndifferentAccess || value.class == ActionController::Parameters
      hash[key] = Hash.new
      value.each { |key2, value2| params_to_hash(hash[key], key2, value2) }
    else
      hash[key] = value.to_s
    end
  end
end
