class AddPinToTopBottomSettings < ActiveRecord::Migration[5.0]
  def up
    Setting.create!(name: "Pinned to Site Top Page ID")
    Setting.create!(name: "Pinned to Home Bottom Page ID")
    Setting.create!(name: "Pinned to Footer Top Page ID")
    Setting.create!(name: "Pinned to Footer Bottom Page ID")
  end

  def down
    Setting.where(name: "Pinned to Site Top Page ID").destroy_all
    Setting.where(name: "Pinned to Home Bottom Page ID").destroy_all
    Setting.where(name: "Pinned to Footer Top Page ID").destroy_all
    Setting.where(name: "Pinned to Footer Bottom Page ID").destroy_all
  end
end
