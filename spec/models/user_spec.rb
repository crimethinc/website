require 'rails_helper'

RSpec.describe User do
  subject(:user) { user }

  describe '#name' do
    describe 'returns the username' do
      subject { user.name }

      let(:user) { build(:user, username: 'example') }

      it { is_expected.to eq 'example' }
    end
  end

  describe '#strip_whitespace' do
    context 'when there is leading and trailing whitespace in a username' do
      subject { user.username }

      let(:user) { create(:user, username: '  padded  ') }

      it { is_expected.to eq 'padded' }
    end
  end

  describe 'role permissions' do
    context 'when the user is a publisher' do
      let(:user) { build(:user, :publisher) }

      it { expect(user.can_publish?).to be true }
      it { expect(user.cant_publish?).to be false }
      it { expect(user.can_delete?).to be true }
      it { expect(user.can_admin_users?).to be true }
    end

    context 'when the user is an author' do
      let(:user) { build(:user, :author) }

      it { expect(user.can_publish?).to be false }
      it { expect(user.cant_publish?).to be true }
    end
  end

  describe 'validations' do
    context 'when passwords shorter than minimum length' do
      let(:user) { build(:user, password: 'short') }

      it 'is expected to be invalid and properly set the error message' do
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end
    end

    context 'when excluded passphrases' do
      let(:user) { build(:user, password: 'mickey fickey fire cracker soap on a rope') }

      it { is_expected.not_to be_valid }
    end
  end
end
