class ApplicationController < ActionController::Base
	include JsonWebToken
	before_action :autenticate_request
	
	def current_user
		@current_user
	end
	private
	
	def autenticate_request
		begin
			header = request.headers['Authorization']
			
			header = header.split(" ").last if header
			decoded = jwt_decode(header)
			@current_user = User.find(decoded[:user_id])
		rescue JWT::DecodeError => e
			render json: {"error" => e}, status: 400
		end
	
	end
end
