class Url < ApplicationRecord
  validate :validate_url_format
  validates :shortened, presence: true, uniqueness: true	
  validates :original, presence: true, uniqueness: true 

  private
  def validate_url_format
    return if original.blank? || valid_url_format?

    errors.add(:original, 'Invalid URL')
  end

  def valid_url_format?
    uri = URI.parse(original)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
