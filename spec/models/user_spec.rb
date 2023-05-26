require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { build :user }
  context 'when validating' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive  }

    it { is_expected.to validate_presence_of(:password) }

    it 'validates the format of email' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'valid.email@domain.com'
      expect(user).to be_valid
    end

  end
end
