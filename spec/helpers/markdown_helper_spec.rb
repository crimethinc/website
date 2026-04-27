require 'rails_helper'

RSpec.describe MarkdownHelper do
  # describe '#render_markdown' do
  #   # TODO: mock out #media_mode?
  #   subject { helper.render_markdown('text').strip }
  #
  #   # TEMP: un-skip this when above is fixed
  #   xit { is_expected.to eq('<p>text</p>') }
  # end

  describe '#render_content' do
    subject { article.content_rendered.strip }

    let(:article) { Article.new(content: 'text', content_format: 'kramdown') }

    it { is_expected.to eq('<p>text</p>') }
  end

  describe '#render_markdown_for' do
    around do |example|
      I18n.with_locale(locale) { example.run }
    end

    before do
      without_partial_double_verification do
        allow(helper).to receive(:media_mode?).and_return(false)
      end
    end

    context 'when the current locale has the markdown file' do
      let(:locale) { :en }

      it 'renders the markdown from that locale' do
        expect(helper.render_markdown_for(page: :litkit_main)).to include('<p>')
      end
    end

    context 'when the current locale lacks the markdown file' do
      let(:locale) { :ca }

      it 'falls back to the default locale instead of raising' do
        expect { helper.render_markdown_for(page: :litkit_main) }.not_to raise_error
        expect(helper.render_markdown_for(page: :litkit_main)).to include('<p>')
      end
    end
  end
end
