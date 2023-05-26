class Api::V1::UrlsController < Api::ApiController 

  def encode
    url = Shortener.call(params["url"], current_user.id)
    if url.is_a?(ActiveRecord::Base)
      shortened = base_url + "/#{url.shortened}"
      render json: { shortened: shortened }, status: :ok
    elsif url.is_a?(ActiveRecord::ActiveRecordError)
      error_message = url.record.errors.full_messages.first
      render json: { error: error_message }, status: :unprocessable_entity
    end
  end
	def decode
			url = Url.find_by(shortened: params["shortened"])
			if url
				render json: {url: url.original}, status: :ok
			else
				render json: { error: "URL not found" }, status: :not_found
			end
	end

	private
	def base_url 
		"#{request.protocol}#{request.host_with_port}"
	end
end
