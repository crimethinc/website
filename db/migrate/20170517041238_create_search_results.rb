class CreateSearchResults < ActiveRecord::Migration[5.0]
  def change
    create_view :search_results, materialized: true

    add_index(:search_results, [:searchable_id, :searchable_type], unique: true)
    add_index(:search_results, :title, using: :gist)
    add_index(:search_results, :subtitle, using: :gist)
    add_index(:search_results, :content, using: :gist)
    add_index(:search_results, :tag_names, using: :gist)
    add_index(:search_results, :category_names, using: :gist)
    add_index(:search_results, :contributor_names, using: :gist)
    add_index(:search_results, :document, using: :gist)
  end
end
