require 'rails_helper'

RSpec.describe RedirectsHelper, type: :helper do
  describe '#redirect_http_status_code' do
    subject { helper.redirect_http_status_code(redirect) }

    context 'with temporary redirect' do
      let(:redirect) { Redirect.new(temporary: true) }

      it { is_expected.to match('TEMPORARY') }
      it { is_expected.to match('302') }
      it { is_expected.to match('badge-warning') }
    end

    context 'with permanent redirect' do
      let(:redirect) { Redirect.new(temporary: false) }

      it { is_expected.to match('PERMANENT') }
      it { is_expected.to match('301') }
      it { is_expected.to match('badge-success') }
    end
  end
end
