class DefaultShadowToOn < ActiveRecord::Migration[5.1]
  def change
    change_column_default :articles, :header_shadow_text, true
  end
end
