require 'rails_helper'

RSpec.describe Shortener do
  let(:original) { 'http://www.long.com' }
  let(:shortened) { 'https://www.localhost:3000/ijwn6xq' }
  let(:user_id) {1}
  describe '.call' do
    subject(:call) { described_class.call(original, user_id) }

    context 'when long URL already exists' do
      before { create(:url, original: original, shortened: shortened, created_by: user_id) }

      it { expect(call.shortened).to eq shortened }
    end

    context 'when long URL does not exist' do
      let(:url) { Url.find_by(original: original) }

      before do
        allow(SecureRandom).to receive(:base64).and_return('f9b5f21')
        call
      end

      it { expect(url).to be_present }
      it { expect(url.shortened).to eq 'f9b5f21' }
    end
  end
end

