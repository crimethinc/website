class AddFeaturedToAllTools < ActiveRecord::Migration[7.2]
  def change
    # logos
    change_table :logos, bulk: true do |t|
      t.boolean  :featured_status, default: false, null: false
      t.datetime :featured_at,     precision: nil
    end

    # podcasts
    change_table :podcasts, bulk: true do |t|
      t.boolean  :featured_status, default: false, null: false
      t.datetime :featured_at, precision: nil
    end

    # episodes
    change_table :episodes, bulk: true do |t|
      t.boolean  :featured_status, default: false, null: false
      t.datetime :featured_at, precision: nil
    end

    # journals
    change_table :journals, bulk: true do |t|
      t.boolean  :featured_status, default: false, null: false
      t.datetime :featured_at, precision: nil
    end

    # videos
    change_table :videos, bulk: true do |t|
      t.boolean  :featured_status, default: false, null: false
      t.datetime :featured_at, precision: nil
    end
  end
end
