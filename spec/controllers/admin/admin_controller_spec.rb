require 'rails_helper'

RSpec.describe Admin::AdminController, type: :controller do
  describe '#admin_title' do
    before do
      controller.stub(:controller_path).and_return('admin/articles')
      controller.stub(:action_name).and_return('edit')
    end
    let(:article) { create(:article, title: 'title', subtitle: 'sub', id: 1) }

    it 'returns the controller action translation if no model passed in' do
      controller.stub(:action_name).and_return('index')
      title = controller.admin_title
      expect(title).to eq('Articles')
    end

    it 'creates title using keys passed in' do
      title = controller.admin_title(article, [:id, :title, :subtitle])
      expect(title).to eq('Editing article 1 title : sub')
    end

    it 'logs error and does not blow up if invalid keys passed' do
      expect(Rails.logger).to receive(:error).with("admin/articles:edit has an issue with the page title")

      title = controller.admin_title(article, [:id, :foo])

      expect(title).to eq('')
    end

    it 'does not blow up if keys not in translation are passed in' do
      title = controller.admin_title(article, [:id, :title, :subtitle, :year])
      expect(title).to eq('Editing article 1 title : sub')
    end
  end
end
