class CreateEpisodes < ActiveRecord::Migration[5.0]
  def change
    create_table :episodes do |t|
      t.references :podcast
      t.string :title
      t.string :subtitle
      t.text :image
      t.string :content

      t.text   :audio_mp3_url
      t.string :audio_mp3_file_size

      t.text   :audio_ogg_url
      t.string :audio_ogg_file_size

      t.text :show_notes
      t.text :transcript

      t.string :audio_length
      t.string :duration
      t.string :audio_type, default: 'audio/mpeg'
      t.string :tags
      t.datetime :published_at

      t.timestamps
    end
  end
end
