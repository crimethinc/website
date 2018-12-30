require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do
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
end
