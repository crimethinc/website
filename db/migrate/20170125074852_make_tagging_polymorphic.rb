class MakeTaggingPolymorphic < ActiveRecord::Migration[5.0]
  def up
    change_table :taggings do |t|
      t.rename :article_id, :taggable_id
      t.string :taggable_type
    end

    # All existing tags are applied to articles
    Tagging.update_all(taggable_type: "Article")
  end

  def down
    change_table :taggings do |t|
      t.rename :taggable_id, :article_id
      t.remove :taggable_type
    end
  end
end
