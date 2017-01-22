class ArticleValidator < ActiveModel::Validator
  def validate(record)
    unless Article.find_by(short_path: record.short_path, id: record.id)
      if Redirect.find_by(source_path: record.short_path) ||
          Article.find_by(short_path: record.short_path)
        record.errors[:base] << "Article Short Path Must Be Unique"
      end
    end
  end
end
