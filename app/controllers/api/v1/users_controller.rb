class Api::V1::UsersController < Api::ApiController 
	skip_before_action :autenticate_request, only: :create
	def create 
		user = User.new(create_params)
		if user.save
			render json: user, status:201
		else
		    render 	json: user.errors, status:400
		end
	end

	private
	def create_params
		params.require(:user).permit(:email, :password)
    end
end
