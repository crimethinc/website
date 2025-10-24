require 'rails_helper'

RSpec.describe RedirectsHelper do
  describe '#redirect_http_status_code' do
    subject { helper.redirect_http_status_code(redirect) }

    context 'with temporary redirect' do
      let(:redirect) { Redirect.new(temporary: true) }

      it { is_expected.to match('TEMPORARY') }
      it { is_expected.to match('302') }
      it { is_expected.to match('bg-warning') }
    end

    context 'with permanent redirect' do
      let(:redirect) { Redirect.new(temporary: false) }

      it { is_expected.to match('PERMANENT') }
      it { is_expected.to match('301') }
      it { is_expected.to match('bg-success') }
    end
  end
end
