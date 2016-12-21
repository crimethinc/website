class CreateEpisodes < ActiveRecord::Migration[5.0]
  def change
    create_table :episodes do |t|
      t.references :podcast
      t.string :title
      t.string :subtitle
      t.text :image
      t.string :content
      t.text :audio_url
      t.string :audio_length
      t.string :audio_type, default: "audio/mpeg"
      t.string :tags

      t.timestamps
    end
  end
end
