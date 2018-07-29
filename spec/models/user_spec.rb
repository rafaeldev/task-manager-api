require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('task@manager.com').for(:email) }

  it { is_expected.to validate_confirmation_of :password }

  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email, created_at, token' do
      user.save!

      allow(Devise).to receive(:friendly_token).and_return('token')

      expect(user.info).to eq "#{user.email} - #{user.created_at} - Token: token"
    end
  end
end
