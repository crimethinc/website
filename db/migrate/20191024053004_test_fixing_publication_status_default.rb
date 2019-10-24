class TestFixingPublicationStatusDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :books,    :publication_status, from: 'draft', to: 0
    change_column_default :journals, :publication_status, from: 'draft', to: 0
    change_column_default :logos,    :publication_status, from: 'draft', to: 0
    change_column_default :pages,    :publication_status, from: 'draft', to: 0
    change_column_default :posters,  :publication_status, from: 'draft', to: 0
    change_column_default :videos,   :publication_status, from: 'draft', to: 0
  end
end
