class CreateBurnedPasswords < ActiveRecord::Migration[5.1]
  def change
    create_table :burned_passwords, id: :string, primary_key: :password_sha1 do |t|
    end
  end
end
