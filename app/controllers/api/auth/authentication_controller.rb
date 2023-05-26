module Api::Auth
	class AuthenticationController < Api::ApiController
		skip_before_action :autenticate_request, only: :login
		def login
			@user = User.find_by(email: params[:email])
			if @user&.valid_password?(params[:password])
				token = jwt_encode(user_id: @user.id)
		
				render json: {"token": token}, status: 200
			else
				render json: {"error": "Unauthorized"}, status: :unauthorized
			end
		end
	end
end