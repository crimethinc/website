require 'rails_helper'

RSpec.describe User do
  describe '#name' do
    it 'returns the username' do
      user = described_class.new(username: 'example')

      expect(user.name).to eq 'example'
    end
  end

  describe '#strip_whitespace' do
    it 'strips leading and trailing whitespace from username' do
      user = create(:user, username: '  padded  ', password: 'x' * 30)

      expect(user.username).to eq 'padded'
    end
  end

  describe 'role permissions' do
    it 'allows publishers to publish' do
      user = build(:user, role: 'publisher')

      expect(user.can_publish?).to be true
      expect(user.cant_publish?).to be false
      expect(user.can_delete?).to be true
      expect(user.can_admin_users?).to be true
    end

    it 'does not allow authors to publish' do
      user = build(:user, role: 'author')

      expect(user.can_publish?).to be false
      expect(user.cant_publish?).to be true
    end
  end

  describe 'validations' do
    it 'rejects passwords shorter than minimum length' do
      user = build(:user, password: 'short')

      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it 'rejects excluded passphrases' do
      user = build(:user, password: 'mickey fickey fire cracker soap on a rope')

      expect(user).not_to be_valid
    end
  end
end
