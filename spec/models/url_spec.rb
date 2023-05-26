require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { build :url }
  context 'when validating' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:original) }
    it { is_expected.to validate_uniqueness_of(:original) }

    it { is_expected.to validate_presence_of(:shortened) }
    it { is_expected.to validate_uniqueness_of(:shortened) }
    it 'validates the format of original' do
      is_expected.to allow_value('http://example.com').for(:original)
      is_expected.not_to allow_value('invalid-url').for(:original)
    end
  end
end
