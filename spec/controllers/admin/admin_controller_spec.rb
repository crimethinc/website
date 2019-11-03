require 'rails_helper'

RSpec.describe Admin::AdminController, type: :controller do
  describe '#admin_title' do
    let(:article) { create(:article, title: 'title', subtitle: 'sub', id: 1) }

    it 'creates title using keys passed in' do
      # these expectations are used to stub out contoller cals and return expected values
      expect(controller).to receive(:controller_path).and_return('admin/articles').at_least(:once)
      expect(controller).to receive(:action_name).and_return('edit').at_least(:once)

      title = controller.admin_title(article, %i[id title subtitle])
      expect(title).to eq('CrimethInc. : Admin : Editing article 1 title : sub')
    end

    it 'logs error and does not blow up if invalid keys passed' do
      # these expectations are used to stub out contoller cals and return expected values
      expect(controller).to receive(:controller_path).and_return('admin/articles').at_least(:once)
      expect(controller).to receive(:action_name).and_return('edit').at_least(:once)

      expect(Rails.logger).to receive(:error).with('admin/articles:edit has an issue with the page title')

      title = controller.admin_title(article, %i[id foo])

      expect(title).to eq('')
    end

    it 'does not blow up if keys not in translation are passed in' do
      # these expectations are used to stub out contoller cals and return expected values
      expect(controller).to receive(:controller_path).and_return('admin/articles').at_least(:once)
      expect(controller).to receive(:action_name).and_return('edit').at_least(:once)

      title = controller.admin_title(article, %i[id title subtitle year])
      expect(title).to eq('CrimethInc. : Admin : Editing article 1 title : sub')
    end
  end

  describe 'when editing' do
    it 'returns the controller action translation if no model passed in' do
      expect(controller).to receive(:controller_path).and_return('admin/articles').at_least(:once)
      expect(controller).to receive(:action_name).and_return('index').at_least(:once)
      title = controller.admin_title
      expect(title).to eq('CrimethInc. : Admin : Articles')
    end
  end
end
