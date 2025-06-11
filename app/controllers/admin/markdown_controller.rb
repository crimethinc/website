module Admin
  class MarkdownController < Admin::AdminController
    # /admin/markdown
    def index
      @title    = 'Markdown Cheatsheet'
      @html_id  = 'markdown'
      @body_id  = 'top'
      @sections = [
        %w[headings links horizontal_rules paragraphs],
        %w[lists bold_and_italics]
      ]
    end
  end
end
