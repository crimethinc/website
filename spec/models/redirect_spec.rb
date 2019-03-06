require 'rails_helper'

RSpec.describe Redirect, type: :model do
  describe '#name' do
    subject { redirect.name }

    let(:redirect) { Redirect.new(source_path: '/source', target_path: '/target') }

    it { is_expected.to eq('/source') }
  end

  describe '#add_leading_slash' do
    before { redirect.add_leading_slash }

    context 'with absolute urls' do
      let(:redirect) { Redirect.new(source_path: 'http://example.com/source', target_path: 'http://example.com/target') }

      specify { expect(redirect.source_path).to eq('http://example.com/source') }
      specify { expect(redirect.target_path).to eq('http://example.com/target') }
    end

    context 'with relative urls' do
      let(:redirect) { Redirect.new(source_path: 'source', target_path: 'target') }

      specify { expect(redirect.source_path).to eq('/source') }
      specify { expect(redirect.target_path).to eq('/target') }
    end

    context 'with relative source path and absolute target path' do
      https_target_path = 'https://example.com/foo/bar'
      let(:redirect) { Redirect.new(source_path: 'source', target_path: https_target_path) }

      specify { expect(redirect.source_path).to eq('/source') }
      specify { expect(redirect.target_path).to eq(https_target_path) }
    end
  end

  describe '#downcase_source_path' do
    before { redirect.downcase_source_path }

    context 'with mixed case' do
      let(:redirect) { Redirect.new(source_path: 'SoUrCe', target_path: 'TaRgEt') }

      specify { expect(redirect.source_path).to eq('source') }
      specify { expect(redirect.target_path).to eq('TaRgEt') }
    end
  end

  describe '#strip_domain_from_target_path' do
    subject { redirect.target_path }

    before { redirect.strip_domain_from_target_path }

    context 'with leading domain' do
      let(:redirect) { Redirect.new(source_path: 'source', target_path: 'http://crimethinc.com/?query=true') }

      it { is_expected.to eq('/?query=true') }
    end

    context 'with external http domain' do
      http_target_path = 'http://example.com/foo/bar'
      let(:redirect) { Redirect.new(source_path: 'source', target_path: http_target_path) }

      it { is_expected.to eq(http_target_path) }
    end

    context 'with external https domain' do
      https_target_path = 'https://example.com/foo/bar'
      let(:redirect) { Redirect.new(source_path: 'source', target_path: https_target_path) }

      it { is_expected.to eq(https_target_path) }
    end
  end

  describe '#delete_duplicates' do
    let(:attributes) { { source_path: 'source', target_path: 'target' } }

    before { 2.times { Redirect.create(attributes) } }

    specify { expect(Redirect.count).to eq(1) }
  end

  describe '#noncircular_redirect' do
    subject { redirect.errors[:target_path] }

    before { redirect.valid? }

    let(:redirect) { Redirect.new(source_path: 'source', target_path: 'source') }

    it { is_expected.to include('redirects to itself') }
  end

  describe '#article_short_path_unique' do
    let(:published_at) { Date.current }

    context 'without creating a redirect if short path exists' do
      it 'raises error' do
        # article = FactoryBot.create(:article, title: 'test', short_path: 'tester', status: status, published_at: published_at)
        # redirect = Redirect.new(source_path: '/tester', target_path: '/test/test')
        # expect{redirect.save!}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Source path has already been taken, Source path is already taken by article short path')
      end
    end
  end
end
