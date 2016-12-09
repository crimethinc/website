class AddPinToTopBottomSettings < ActiveRecord::Migration[5.0]
  def up
    Setting.create!(name: "Pinned to Top Page ID")
    Setting.create!(name: "Pinned to Bottom Page ID")
  end

  def down
    Setting.where(name: "Pinned to Top Page ID").destroy_all
    Setting.where(name: "Pinned to Bottom Page ID").destroy_all
  end
end
