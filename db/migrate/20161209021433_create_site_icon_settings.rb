class CreateSiteIconSettings < ActiveRecord::Migration[5.0]
  def up
    [57, 60, 70, 72, 76, 114, 120, 144, 150, 152, 180, 192, 200, 300, 310, 500, 600].each do |size|
      Setting.create!(name: "Icon #{size}x#{size}", form_element: "url_field")
    end

    [
      "Icon 310x150",
      "Favicon (32x32)",
      "MS Application: Tile Image",
      "Mask Icon: SVG"
    ].each do |setting_name|
      Setting.create!(name: setting_name, form_element: "url_field")
    end

    [
      "MS Application: Tile Color",
      "Mask Icon: Color",
      "Theme Color"
    ].each do |setting_name|
      Setting.create!(name: setting_name)
    end
  end

  def down
    [57, 60, 70, 72, 76, 114, 120, 144, 150, 152, 180, 192, 200, 300, 310, 500, 600].each do |size|
      Setting.find_by(name: "Icon #{size}x#{size}", form_element: "url_field").destroy
    end

    [
      "Icon 310x150",
      "Favicon (32x32)",
      "MS Application: Tile Image",
      "MS Application: Tile Color",
      "Mask Icon: SVG",
      "Mask Icon: Color",
      "Theme Color"
    ].each do |setting_name|
      Setting.find_by(name: setting_name).destroy
    end
  end
end
