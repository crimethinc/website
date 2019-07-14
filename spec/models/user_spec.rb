require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name' do
    subject { user.name }

    context 'without display_name' do
      let(:user) { User.create(username: 'example', password: 'x' * 30) }

      it { is_expected.to eq('example') }
    end
  end
end
