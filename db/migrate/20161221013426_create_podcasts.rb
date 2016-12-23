class CreatePodcasts < ActiveRecord::Migration[5.0]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :subtitle
      t.string :slug
      t.string :language
      t.string :copyright
      t.text :image
      t.text :content
      t.string :itunes_author
      t.string :itunes_categories
      t.boolean :itunes_explicit, default: true
      t.string :tags
      t.string :itunes_summary
      t.string :itunes_owner_name
      t.string :itunes_owner_email
      t.text :itunes_url
      t.text :overcast_url
      t.text :pocketcasts_url

      t.timestamps
    end
  end
end
