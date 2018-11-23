require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do
  describe '#render_markdown' do
    # TODO: mock out #media_mode?
    subject { helper.render_markdown('text').strip }

    # TEMP: un-skip this when above is fixed
    xit { is_expected.to eq('<p>text</p>') }
  end
end
