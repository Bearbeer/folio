class JsonWebToken
  class << self
    def decode(token)
      HashWithIndifferentAccess.new(JWT.decode(token, ENV['SECRET_KEY_BASE']).first)
    rescue
      nil
    end
  end
end