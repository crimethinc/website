class AddNullConstraintToArticleTimeZone < ActiveRecord::Migration[5.1]
  def change
    # in theory, any row in the articles table was written with a
    # time_zone of UTC
    change_column_null :articles, :published_at_tz, false, 'UTC'
    change_column_null :episodes, :published_at_tz, false, 'UTC'
    change_column_null :pages, :published_at_tz, false, 'UTC'
    change_column_null :videos, :published_at_tz, false, 'UTC'
  end
end
