class AddTimeZoneToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :published_at_tz, :string, default: "Pacific Time (US & Canada)"
    add_column :episodes, :published_at_tz, :string, default: "Pacific Time (US & Canada)"
    add_column :pages, :published_at_tz, :string, default: "Pacific Time (US & Canada)"
    add_column :videos, :published_at_tz, :string, default: "Pacific Time (US & Canada)"
  end
end
