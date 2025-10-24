require 'rails_helper'

RSpec.describe Admin::AdminController do
  describe '#admin_title' do
    let(:article) { create(:article, title: 'title', subtitle: 'sub', id: 1) }

    it 'creates title using keys passed in' do
      # these expectations are used to stub out contoller cals and return expected values
      allow(controller).to receive_messages(controller_path: 'admin/articles', action_name: 'edit')

      title = controller.admin_title(article, %i[id title subtitle])
      expect(title).to eq('CrimethInc. : Admin : Editing article 1 title : sub')

      expect(controller).to have_received(:controller_path).at_least(:once)
      expect(controller).to have_received(:action_name).at_least(:once)
    end

    it 'does not blow up if invalid keys passed' do
      title = controller.admin_title(article, %i[id foo])

      expect(title).to eq('')
    end

    it 'does not blow up if keys not in translation are passed in' do
      # these expectations are used to stub out contoller cals and return expected values
      allow(controller).to receive_messages(controller_path: 'admin/articles', action_name: 'edit')

      title = controller.admin_title(article, %i[id title subtitle year])
      expect(title).to eq('CrimethInc. : Admin : Editing article 1 title : sub')

      expect(controller).to have_received(:controller_path).at_least(:once)
      expect(controller).to have_received(:action_name).at_least(:once)
    end
  end

  describe 'when editing' do
    it 'returns the controller action translation if no model passed in' do
      allow(controller).to receive_messages(controller_path: 'admin/articles', action_name: 'index')

      title = controller.admin_title
      expect(title).to eq('CrimethInc. : Admin : Articles')

      expect(controller).to have_received(:controller_path).at_least(:once)
      expect(controller).to have_received(:action_name).at_least(:once)
    end
  end
end
