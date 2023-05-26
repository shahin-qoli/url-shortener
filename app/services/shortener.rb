class Shortener


	def self.call(original_url, user_id)
	    new(original_url, user_id).call
	end
	
	def call
		begin
			url = Url.find_by_original(@original_url)
			url ||= create_url
			url.save!
			url
		rescue ActiveRecord::RecordInvalid => e
			e
		end
	end
	
	private

	def initialize(original_url, user_id)
		@original_url = original_url
		@user_id = user_id
	end

	#be aware of creating secure random duplicaty
	def create_url
		Url.new(original: @original_url, shortened: SecureRandom.base64(6), user_id: @user_id)
	end
end