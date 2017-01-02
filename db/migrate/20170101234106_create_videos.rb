class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.text       :title, :subtitle, :content, :tweet, :summary
      t.text       :image, :image_description
      t.string     :content_format, default: "kramdown"

      t.string     :slug, :quality, :duration, :vimeo_id
      t.datetime   :published_at

      t.string     :year, :month, :day

      t.timestamps
    end
  end
end
