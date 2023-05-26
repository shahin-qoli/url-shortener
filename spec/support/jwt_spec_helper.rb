module JwtSpecHelper
  def generate_jwt_token(payload)
    # Replace with your JWT secret key
    secret_key = 'shqshq09353647272shqshq'
    JWT.encode(payload, secret_key, 'HS256')
  end
end
